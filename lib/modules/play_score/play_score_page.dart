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
                          double topPadding = 0, bottomPadding = 0;
                          if (el is ABCTone) {
                            s = '\ue050\ue01a-\ue01a-\ue01a-';
                          } else if (el is ABCNote) {
                            String note = '';

                            switch (el.note) {
                              case 'A':
                                topPadding = spaceSize;

                              case 'B':
                                topPadding = 0;

                              case 'C':
                                topPadding = 6 * spaceSize;

                              case 'D':
                                topPadding = 5 * spaceSize;

                              case 'E':
                                topPadding = 4 * spaceSize;

                              case 'F':
                                topPadding = 3 * spaceSize;

                              case 'G':
                                topPadding = 2 * spaceSize;

                              case 'a':
                                bottomPadding = 6 * spaceSize;

                              case 'b':
                                bottomPadding = 7 * spaceSize;

                              case 'c':
                                bottomPadding = 1 * spaceSize;
                              case 'd':
                                bottomPadding = 2 * spaceSize;

                              case 'e':
                                bottomPadding = 3 * spaceSize;

                              case 'f':
                                bottomPadding = 4 * spaceSize;

                              case 'g':
                                bottomPadding = 5 * spaceSize;
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
                                padding: EdgeInsets.only(
                                    top: topPadding, bottom: bottomPadding),
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

                    countdownDuration = 4;

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

                    var shell = Shell();

                    // await shell.run(
                    //     'python /home/marcelo/Documents/GitHub/tutor_musical/external/python/getNotes.py /home/marcelo/Documents/GitHub/tutor_musical/assets/rec/gravacao.wav 44100');


                    await shell.run(
                        'python /home/marcelo/Documents/GitHub/tutor_musical/external/python/notes_process.py');

                    print(initTime.map((e) => e / 60).toList());
                    notes(
                        initTime.map((e) => e / 60).toList(),
                        File(
                            "/home/marcelo/Documents/GitHub/tutor_musical/assets/rec/piano_format.txt"));
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

        if (!noteDuration.containsKey(nomeNota) || duracaoNota > noteDuration[nomeNota]!) {
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
