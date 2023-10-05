import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:process_run/process_run.dart';
import 'package:tutor_musical/modules/share/abc/abc_parser.dart';
import 'package:tutor_musical/modules/share/ffi/rec_c++.dart';

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
[L:1/4] G/ A/ | B d | d B | c c | z G/ A/ | B d | d c | B2 |
[L:1/8] z G G A | B2 d2 | z d c B | G2 c2 | z B B A | A2 B2 | z A A G | G22 |
''';

    setState(() {
      score = parse(abcText);
    });
  }

  ABCMusic? score;
  double length = 4;
  double andamento = 60;
  ScrollController controller = ScrollController();
  int countdownDuration = 4;

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
                controller.animateTo(3000,
                    duration: const Duration(seconds: 100),
                    curve: Curves.linear);
              },
              icon: Icon(
                Icons.play_arrow_outlined,
                size: 50,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            IconButton(
              onPressed: () {
                controller.animateTo(0,
                    duration: const Duration(milliseconds: 1),
                    curve: Curves.linear);
              },
              icon: const Icon(
                Icons.stop_outlined,
                size: 50,
                color: Colors.red,
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: controller,
                child: Row(
                  children: score != null
                      ? score!.elements.map((el) {
                          String s = '';
                          double t = 0, b = 0;
                          if (el is ABCTone) {
                            s = '\ue050\ue01a-\ue01a-\ue01a-';
                          } else if (el is ABCNote) {
                            String note = '';

                            switch (el.note) {
                              case 'A':
                                t = spaceSize;

                              case 'B':
                                t = 0;

                              case 'C':
                                t = 6 * spaceSize;

                              case 'D':
                                t = 5 * spaceSize;

                              case 'E':
                                t = 4 * spaceSize;

                              case 'F':
                                t = 3 * spaceSize;

                              case 'G':
                                t = 2 * spaceSize;

                              case 'a':
                                b = 6 * spaceSize;

                              case 'b':
                                b = 7 * spaceSize;

                              case 'c':
                                b = 1 * spaceSize;
                              case 'd':
                                b = 2 * spaceSize;

                              case 'e':
                                b = 3 * spaceSize;

                              case 'f':
                                b = 4 * spaceSize;

                              case 'g':
                                b = 5 * spaceSize;
                            }

                            double n = length;
                            if (el.duration != null &&
                                el.duration!.isNotEmpty) {
                              for (var e in el.duration!) {
                                n = e.isMult ? n * 2 : n / 2;
                              }
                              // print(n);
                            }
                            switch (n) {
                              case 4:
                                note = '\uE1D2-';
                                if (initTime.isNotEmpty) {
                                  initTime.add(initTime.last + (andamento * 4));
                                }
                              case 2:
                                note = '\uE1D3-';
                                if (initTime.isNotEmpty) {
                                  initTime.add(initTime.last + (andamento * 2));
                                }
                              case 1:
                                note = '\uE1D5-';
                                if (initTime.isNotEmpty) {
                                  initTime.add(initTime.last + (andamento * 1));
                                }
                              case 0.5:
                                note = '\uE1D7';
                                if (initTime.isNotEmpty) {
                                  initTime
                                      .add(initTime.last + (andamento * 0.5));
                                }
                              case 0.25:
                                note = '\uE1D9';
                                if (initTime.isNotEmpty) {
                                  initTime
                                      .add(initTime.last + (andamento * 0.25));
                                }
                            }

                            s = note;
                          } else if (el is ABCPause) {
                            String pause = '';
                            double n = length;
                            if (el.duration != null &&
                                el.duration!.isNotEmpty) {
                              for (var e in el.duration!) {
                                n = e.isMult ? n * 2 : n / 2;
                              }
                              // print(n);
                            }
                            switch (n) {
                              case 4:
                                pause = '\uE4E3-';
                                if (initTime.isNotEmpty) {
                                  initTime.add(initTime.last + (andamento * 4));
                                }
                              case 2:
                                pause = '\uE4E4-';
                                if (initTime.isNotEmpty) {
                                  initTime.add(initTime.last + (andamento * 2));
                                }
                              case 1:
                                pause = '\uE4E5-';
                                if (initTime.isNotEmpty) {
                                  initTime.add(initTime.last + (andamento * 1));
                                }
                              case 0.5:
                                pause = '\uE4E6-';
                                if (initTime.isNotEmpty) {
                                  initTime
                                      .add(initTime.last + (andamento * 0.5));
                                }
                              case 0.25:
                                pause = '\uE4E7-';
                                if (initTime.isNotEmpty) {
                                  initTime
                                      .add(initTime.last + (andamento * 0.25));
                                }
                            }

                            s = '${pause}';
                          } else if (el is ABCCompasseSeparator) {
                            s = '\ue030-';
                          } else if (el is ABCLength) {
                            length = 4 *
                                el.length; // length = 1/4 ==> 1/4 de semibreve
                          }

                          return Row(
                            children: [
                              Text(
                                '\ue020\ue01a',
                                style: TextStyle(
                                  fontFamily: 'Bravura',
                                  fontSize: 5 * spaceSize,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontFeatures: const [
                                    FontFeature.enable('liga'),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: t, bottom: b),
                                child: Text(
                                  s,
                                  style: TextStyle(
                                    fontFamily: 'Bravura',
                                    fontSize: 5 * spaceSize,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontFeatures: const [
                                      FontFeature.enable('liga'),
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                '\ue020',
                                style: TextStyle(
                                  fontFamily: 'Bravura',
                                  fontSize: 5 * spaceSize,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontFeatures: const [
                                    FontFeature.enable('liga'),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList()
                      : [],
                ),
              ),
              FilledButton(
                  onPressed: () async {
                    // rec.recoder();

                    for (; countdownDuration >= 0; countdownDuration--) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text('$countdownDuration'),
                          );
                        },
                      );
                      await Future.delayed(const Duration(milliseconds: 950));
                    Navigator.pop(context);
                    }


                    controller.animateTo(3000,
                        duration: const Duration(seconds: 100),
                        curve: Curves.linear);

                    await compute(rec.recoder, null);

                    // var shell = Shell();

                    // await shell.run(
                    //     'python /home/marcelo/Documents/GitHub/tutor_musical/external/python/getNotes.py /home/marcelo/Documents/GitHub/tutor_musical/assets/rec/gravacao.wav 44100');
                    // final mostFrequentNotes = getMostRepeatedNotes(initTime);

                    // print(mostFrequentNotes);
                  },
                  child: const Text('Gravar'))
            ],
          ),
        ),
      ),
    );
  }
}

List<String> getMostRepeatedNotes(List<double> timeIntervals) {
  final File file =
      File('/home/marcelo/Documents/GitHub/tutor_musical/assets/rec/notes.txt');
  final List<String> notes = file.readAsLinesSync();

  final List<String> result = [];

  for (int i = 0; i < timeIntervals.length - 1; i++) {
    final startTime = timeIntervals[i];
    final endTime = timeIntervals[i + 1];

    final notesInInterval = notes.where((noteEntry) {
      final parts = noteEntry.split(',');
      final timestamp = double.parse(parts[0]);
      return timestamp >= startTime && timestamp < endTime;
    }).map((noteEntry) {
      final parts = noteEntry.split(',');
      return parts[1];
    });

    final notesMap = <String, int>{};
    String mostRepeatedNote = '';

    for (final note in notesInInterval) {
      notesMap[note] = (notesMap[note] ?? 0) + 1;
      if (mostRepeatedNote.isEmpty ||
          notesMap[note]! > notesMap[mostRepeatedNote]!) {
        mostRepeatedNote = note;
      }
    }

    result.add(mostRepeatedNote);
  }

  return result;
}
