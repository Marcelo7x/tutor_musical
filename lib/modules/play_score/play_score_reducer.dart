import 'dart:io';
import 'dart:math';

import 'package:asp/asp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:process_run/process_run.dart';

import '../share/abc_parser.dart';
import '../share/score_element.dart';
import '../share/score_element_handler.dart';
import 'play_score_atom.dart';

class PlayScoreReducer extends Reducer {
  PlayScoreReducer() {
    on(() => [openRecoder], _openRecoder);
    on(() => [closeRecoder], _closeRecoder);
    on(() => [playScore], _play);
    on(() => [stopScore], _stop);
    on(() => [processUserPerformace], _processUserPerformace);
    on(() => [andamento], _setAndamento);
    on(() => [scoreParser], _scoreParser);
    on(() => [buildScore], _buidScore);
  }

  int initDelay = 0;

  _setAndamento() {
    _buidScore();
  }

  _buidScore() {
    scoreHandler.value = ScoreElementHandler(
        scoreElements: scoreABC.value!,
        spaceSize: spaceSize.value,
        lastLength: 1,
        andamento: andamento.value);

    colorChangeStreams.value = scoreHandler.value!.elements
        .map((e) => Stream<int>.periodic(
            Duration(milliseconds: (e.initTime * 1000).toInt()), (j) => j))
        .toList();
  }

  _scoreParser() {
    final data = Modular.args.data as String;
    print('partitura: ' + data);

    final file = File(data);

    final abcText = file.readAsStringSync();

    scoreABC.value = parse(abcText);
  }

  _openRecoder() async {
    recoderIsRunning.value = true;
    int scoreTimeDuration =
        (scoreHandler.value!.elements.last.initTime.toInt() +
                scoreHandler.value!.elements.last.length.toInt() +
                ((60 / scoreHandler.value!.andamento) * 4))
            .toInt();

    initDelay = DateTime.now().millisecondsSinceEpoch + 1000;

    compute(recoder.value.recoder,
        [scoreTimeDuration, initDelay, true, andamento.value]).then((value) {
      recoderIsRunning.value = false;
      print(
          'Time C++: ${DateTime.fromMillisecondsSinceEpoch(value, isUtc: false)}');
      recoderIsRunning.value = false;
    }).onError((error, stackTrace) {
      print(error);
      recoderIsRunning.value = false;
    });
  }

  _closeRecoder() {}

  _play() async {
    final countdownTime = ((60 / scoreHandler.value!.andamento) * 4);
    while (DateTime.now().millisecondsSinceEpoch <
        initDelay + (countdownTime.toInt() * 1000) - 100) {}
    scoreState.value = PlayingScoreState();
  }

  _stop() {
    scoreState.value = ViewScoreState();
  }

  _processUserPerformace() async {
    state.value = LoadingPlayScoreState();

    await _pythonPerformaceProcess();

    _comparator();

    state.value = ReadyPlayScoreState();
    scoreState.value = ResultScoreState();
  }

  _pythonPerformaceProcess() async {
    var shell = Shell();

    await shell.run(
        'python /home/marcelo/Documents/GitHub/tutor_musical/external/python/notes_process.py');
  }

  _comparator() {
    const String filePath =
        "/home/marcelo/Documents/GitHub/tutor_musical/assets/rec/piano_format.txt";

    // Read the file and split each line into parts
    final List<String> lines = File(filePath).readAsLinesSync();
    final List<List<String>> parts =
        lines.map((line) => line.split(',')).toList();

    List<List<String>> acertos = [];

    final countdownTime = ((60 / scoreHandler.value!.andamento) * 4);
    num diffTime = (countdownTime.toInt());

    int turingTransposition = 12 - turingInstrument.value.interval.values.first;

    for (var i = 0; i < scoreHandler.value!.elements.length; i++) {
      if (scoreHandler.value!.elements[i] is! NoteScoreElement) {
        continue;
      }

      Map<String, double> noteWithMaxTime = {};
      double endtime = scoreHandler.value!.elements[i].initTime +
          scoreHandler.value!.elements[i].length;
      final init = scoreHandler.value!.elements[i].initTime;

      for (final el in parts) {
        double elStartTime = double.parse(el[0]) - diffTime.abs();
        double elEndTime = double.parse(el[1]) - diffTime.abs();
        // double elMidiNumber = double.parse(el[2]);
        String note = el[2].toString();
        // String note = el[3];

        if (elStartTime <= endtime && elEndTime >= init) {
          if (elEndTime <= endtime) {
            noteWithMaxTime[note] = elEndTime - max(elStartTime, init);
          } else if (elStartTime >= init) {
            noteWithMaxTime[note] = min(elEndTime, endtime) - elStartTime;
          } else if (elEndTime >= endtime && elStartTime <= init) {
            noteWithMaxTime[note] = endtime - init;
          } else if (elEndTime <= endtime && elStartTime <= init) {
            noteWithMaxTime[note] = elEndTime - init;
          } else if (elEndTime >= endtime && elStartTime >= init) {
            noteWithMaxTime[note] = endtime - elStartTime;
          }
        } else if (elStartTime > endtime) {
          break;
        }
      }

      double maxDuration = 0;
      String maxDurationNote = '';
      for (var entry in noteWithMaxTime.entries) {
        if (entry.value > maxDuration) {
          maxDuration = entry.value;
          maxDurationNote = entry.key;
        }
      }

      String noteScoreElementNote =
          (scoreHandler.value!.elements[i] as NoteScoreElement).note.note;

      final initT =
          (scoreHandler.value!.elements[i] as NoteScoreElement).initTime;

      final l = (scoreHandler.value!.elements[i] as NoteScoreElement).length;
      if (maxDurationNote.isNotEmpty) {
        acertos.add([
          noteScoreElementNote,
          initT.toString(),
          l.toString(),
          maxDurationNote
        ]);

        print(
            '$maxDurationNote ${_midiToNote(double.parse(maxDurationNote).toInt() + turingTransposition)}');

        final noteReference =
            (scoreHandler.value!.elements[i] as NoteScoreElement).note;

        String acidentReference = '';
        if (noteReference.accident == '^') {
          acidentReference = '#';
        } else if (noteReference.accident == '_') {
          acidentReference = 'b';
        }

        final noteReferenceName = noteReference.note.toUpperCase() + acidentReference;
        
        final List<String> noteUser = _midiToNote(
                double.parse(maxDurationNote).toInt() + turingTransposition);
        if (noteUser.contains(noteReferenceName)) {
          (scoreHandler.value!.elements[i] as NoteScoreElement).rangRight =
              true;
        } else {
          (scoreHandler.value!.elements[i] as NoteScoreElement).rangRight =
              false;
        }
      } else {
        acertos
            .add([noteScoreElementNote, initT.toString(), l.toString(), '-']);
        (scoreHandler.value!.elements[i] as NoteScoreElement).rangRight = false;
      }
    }

    print('Acertos: ');
    for (var e in acertos) {
      print(e);
    }
  }

  List<String> _midiToNote(int midiNumber) {
    const notes = [
      ['C', 'B#'],
      ['C#', 'Db'],
      ['D'],
      ['D#', 'Eb'],
      ['E', 'Fb'],
      ['F', 'E#'],
      ['F#', 'Gb'],
      ['G'],
      ['G#', 'Ab'],
      ['A'],
      ['A#', 'Bb'],
      ['B', 'Cb']
    ];

    var noteNumber = midiNumber % 12;
    // var octave = (midiNumber ~/ 12) - 1; // Divisão inteira

    return notes[noteNumber];
  }
}
