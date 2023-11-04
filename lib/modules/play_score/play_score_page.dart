import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:process_run/process_run.dart';
import 'package:tutor_musical/modules/share/abc/abc_parser.dart';
import 'package:tutor_musical/modules/share/ffi/rec_c++.dart';
import 'package:tutor_musical/modules/share/score_element.dart';

import '../share/score_element_handler.dart';

class PlayScorePage extends StatefulWidget {
  const PlayScorePage({super.key});

  @override
  State<PlayScorePage> createState() => _PlayScorePageState();
}

class _PlayScorePageState extends State<PlayScorePage> {
  @override
  void initState() {
    final abcText = '''
X:1
T:Asa Branca
C:Luiz Gonzaga
M:2/4
K:G
[L:1/4] z G/ A/ | B d | d B | c c | z G/ A/ | B d | d c | B2 |
[L:1/8] z G G A | B2 d2 | z d c B | G2 c2 | z B B A | A2 B2 | z A A G | G22 |
''';

//     final abcText = '''
// X:1
// T:Escala
// C:Teste
// M:4/4
// K:G
// [L:1/4] C D E F | G A B c |
// ''';

    setState(() {
      score = parse(abcText);
      handler = ScoreElementHandler(
        scoreElements: score!,
        spaceSize: 25,
        lastLength: length,
        // initTime: initTime,
        andamento: andamento,
      );

      colorChangeStreams = handler!.elements
          .map((e) => Stream<int>.periodic(
              Duration(milliseconds: (e.initTime * 1000).toInt()), (j) => j))
          .toList();

      // print(handler?.initTime);
      // for (var e in handler!.elements) {
      //   print('${e.initTime} ${e.length}');
      // }
    });
  }

  ABCMusic? score;
  double length = 4;
  double andamento = 60;
  final andamentoController = TextEditingController(text: '60');
  ScrollController controller = ScrollController();
  int countdownDuration = 4;
  bool play = false;
  int? coloredIndex;

  ScoreElementHandler? handler;
  List<Stream<int>> colorChangeStreams = [
    Stream<int>.periodic(const Duration(seconds: 1), (j) => j)
  ];

  final rec = Recoder();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    final availableHeight = MediaQuery.sizeOf(context).height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    const spaceSize = 25.0;
    final initTime = <double>[0];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                // controller.animateTo(3000,
                //     duration: const Duration(seconds: 100),
                //     curve: Curves.linear);
              },
              icon: Icon(
                Icons.play_arrow_outlined,
                size: 50,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            IconButton(
              onPressed: () {
                // controller.animateTo(0,
                //     duration: const Duration(milliseconds: 1),
                //     curve: Curves.linear);
              },
              icon: const Icon(
                Icons.stop_outlined,
                size: 50,
                color: Colors.red,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 300,
              child: Row(
                children: [
                  Text(
                    'Andamento: ',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: 18,
                        ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        andamento--;
                        andamentoController.text = andamento.toInt().toString();
                        handler = ScoreElementHandler(
                          scoreElements: score!,
                          spaceSize: 25,
                          lastLength: length,
                          // initTime: initTime,
                          andamento: andamento,
                        );
                      });
                    },
                    icon: Icon(
                      Icons.remove,
                      size: 50,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(
                    width: 55,
                    child: TextField(
                      controller: andamentoController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        // labelText: 'Andamento',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          andamento = double.parse(value);
                          handler = ScoreElementHandler(
                            scoreElements: score!,
                            spaceSize: 25,
                            lastLength: length,
                            // initTime: initTime,
                            andamento: andamento,
                          );
                        });
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        andamento++;
                        andamentoController.text = andamento.toInt().toString();
                        handler = ScoreElementHandler(
                          scoreElements: score!,
                          spaceSize: 25,
                          lastLength: length,
                          // initTime: initTime,
                          andamento: andamento,
                        );
                      });
                    },
                    icon: Icon(
                      Icons.add,
                      size: 50,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          // height: availableHeight,
          width: width,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                score?.title ?? '',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 34),
              ),
              Text(
                score?.composer ?? '',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontSize: 20),
              ),
              const SizedBox(height: 50),
              Wrap(
                spacing: 0,
                children: [
                  if (play)
                    for (int i = 0; i < handler!.elements.length - 1; i++)
                      StreamBuilder<int>(
                        stream: colorChangeStreams[i],
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              handler!.elements[i].length != 0) {
                            WidgetsBinding.instance
                                .addPostFrameCallback((timeStamp) {
                              setState(() {
                                coloredIndex = i;
                              });
                            });
                          }
                          // bool shouldColor = snapshot.hasData && handler!.elements[i].length != 0 && i == coloredIndex;
                          return handler!.buildRow(
                              context, handler!.elements[i],
                              color: i == coloredIndex
                                  ? Theme.of(context).colorScheme.primary
                                  : null);
                        },
                      ),
                  if (!play)
                    for (int i = 0; i < handler!.elements.length - 1; i++)
                      handler!.buildRow(context, handler!.elements[i]),
                ],
              ),
              FilledButton(
                  onPressed: () async {
                    colorChangeStreams = handler!.elements
                        .map((e) => Stream<int>.periodic(
                            Duration(milliseconds: (e.initTime * 1000).toInt()),
                            (j) => j))
                        .toList();
                    // rec.recoder();

                    // countdownDuration = 2;

                    // for (; countdownDuration >= 1; countdownDuration--) {
                    //   showDialog(
                    //     context: context,
                    //     builder: (context) {
                    //       return AlertDialog(
                    //         content: Text('$countdownDuration'),
                    //       );
                    //     },
                    //   );
                    //   await Future.delayed(const Duration(milliseconds: 950));
                    //   Navigator.pop(context);
                    // }

                    // bool acabou = false;

                    // compute(rec.recoder, null).then((value) {
                    //   acabou = true;
                    // }).onError((error, stackTrace) {
                    //   acabou = true;
                    // });

                    setState(() {
                      play = true;
                    });

                    // while (!acabou) {
                    //   await Future.delayed(const Duration(milliseconds: 100));
                    // }

                    // var shell = Shell();

                    // // await shell.run(
                    // //     'python /home/marcelo/Documents/GitHub/tutor_musical/external/python/getNotes.py /home/marcelo/Documents/GitHub/tutor_musical/assets/rec/gravacao.wav 44100');

                    // await shell.run(
                    // 'python /home/marcelo/Documents/GitHub/tutor_musical/external/python/notes_process.py');

                    // Define the path to the file
                    final String filePath =
                        "/home/marcelo/Documents/GitHub/tutor_musical/assets/rec/piano_format.txt";

                    // Read the file and split each line into parts
                    final List<String> lines = File(filePath).readAsLinesSync();
                    final List<List<String>> parts =
                        lines.map((line) => line.split(',')).toList();

                    List<List<String>> acertos = [];

                    for (var i = 0; i < handler!.elements.length; i++) {
                      if (handler!.elements[i] is! NoteScoreElement) {
                        continue;
                      }

                      Map<String, double> noteWithMaxTime = {};
                      double endtime = handler!.elements[i].initTime +
                          handler!.elements[i].length;
                      final init = handler!.elements[i].initTime;

                      for (final el in parts) {
                        double elStartTime = double.parse(el[0]);
                        double elEndTime = double.parse(el[1]);
                        String note = el[3];

                        if (elStartTime <= endtime && elEndTime >= init) {
                          if (elEndTime <= endtime) {
                            noteWithMaxTime[note] =
                                elEndTime - max(elStartTime, init);
                          } else if (elStartTime >= init) {
                            noteWithMaxTime[note] =
                                min(elEndTime, endtime) - elStartTime;
                          } else if (elEndTime >= endtime &&
                              elStartTime <= init) {
                            noteWithMaxTime[note] = endtime - init;
                          } else if (elEndTime <= endtime &&
                              elStartTime <= init) {
                            noteWithMaxTime[note] = elEndTime - init;
                          } else if (elEndTime >= endtime &&
                              elStartTime >= init) {
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
                          (handler!.elements[i] as NoteScoreElement).note.note;

                      final initT =
                          (handler!.elements[i] as NoteScoreElement).initTime;

                      final l =
                          (handler!.elements[i] as NoteScoreElement).length;
                      if (maxDurationNote.isNotEmpty) {
                        acertos.add([
                          noteScoreElementNote,
                          initT.toString(),
                          l.toString(),
                          maxDurationNote
                        ]);
                      } else {
                        acertos.add([
                          noteScoreElementNote,
                          initT.toString(),
                          l.toString(),
                          '-'
                        ]);
                      }
                    }

                    print('Acertos: ');
                    for (var e in acertos) {
                      print(e);
                    }
                  },
                  child: const Text('Gravar'))
            ],
          ),
        ),
      ),
    );
  }
}

void notes(List<double> timeIntervals, File arquivo) {
  List<String> lines = arquivo.readAsLinesSync();

  Map<String, double> noteDuration = {};

  for (String line in lines) {
    List<String> parts = line.split(',');
    if (parts.length != 4) {
      print("Formato de linha incorreto: $line");
      continue;
    }

    double tempoInicial = double.parse(parts[0]);
    double tempoFinal = double.parse(parts[1]);
    double valorMidi = double.parse(parts[2]);
    String nomeNota = parts[3];

    for (int i = 0; i < timeIntervals.length - 1; i++) {
      double limiteInicial = timeIntervals[i];
      double limiteFinal = timeIntervals[i + 1];

      if (tempoInicial <= limiteFinal && tempoFinal >= limiteInicial) {
        double duracaoNota = tempoFinal - tempoInicial;

        if (!noteDuration.containsKey(nomeNota) ||
            duracaoNota > noteDuration[nomeNota]!) {
          noteDuration[nomeNota] = duracaoNota;
        }
      }
    }
  }

  List<String> result = [];
  for (String nota in noteDuration.keys) {
    result.add(nota);
  }

  if (result.isEmpty) {
    print("Nenhuma nota encontrada nos intervalos especificados.");
  } else {
    print("Notas com maior duração em cada intervalo:");
    print(result);
  }
}
