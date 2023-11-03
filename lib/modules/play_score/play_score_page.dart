import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:process_run/process_run.dart';
import 'package:tutor_musical/modules/share/abc/abc_parser.dart';
import 'package:tutor_musical/modules/share/ffi/rec_c++.dart';

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

      print(handler?.initTime);
      for (var e in handler!.elements) {
        print('${e.initTime} ${e.length}');
      }
    });
  }

  ABCMusic? score;
  double length = 4;
  double andamento = 70;
  ScrollController controller = ScrollController();
  int countdownDuration = 4;
  bool play = false;

  ScoreElementHandler? handler;
  List<Stream<int>> colorChangeStreams = [
    Stream<int>.periodic(Duration(seconds: 1), (j) => j)
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
                    if(play)
                  for (int i = 0; i < handler!.elements.length - 1; i++)
                    StreamBuilder<int>(
                      stream: colorChangeStreams[i],
                      builder: (context, snapshot) {
                        return handler!.buildRow(context, handler!.elements[i],
                            color: snapshot.hasData &&
                                    handler!.elements[i].length != 0
                                ? Theme.of(context).colorScheme.primary
                                : null);
                      },
                    ),
                      if(!play)
                  for (int i = 0; i < handler!.elements.length - 1; i++)

                      handler!.buildRow(context, handler!.elements[i]),
                ],
              ),
              FilledButton(
                  onPressed: () async {
                    // rec.recoder();

                    countdownDuration = 4;

                    for (; countdownDuration >= 1; countdownDuration--) {
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

                    setState(() {
                      play = true;
                    });

                    // controller.animateTo(3000,
                    //     duration: const Duration(seconds: 100),
                    //     curve: Curves.linear);

                    // await compute(rec.recoder, null);

                    // var shell = Shell();

                    // await shell.run(
                    //     'python /home/marcelo/Documents/GitHub/tutor_musical/external/python/getNotes.py /home/marcelo/Documents/GitHub/tutor_musical/assets/rec/gravacao.wav 44100');

                    // await shell.run(
                    //     'python /home/marcelo/Documents/GitHub/tutor_musical/external/python/notes_process.py');

                    // print(initTime.map((e) => e / 60).toList());
                    // notes(
                    //     initTime.map((e) => e / 60).toList(),
                    //     File(
                    //         "/home/marcelo/Documents/GitHub/tutor_musical/assets/rec/piano_format.txt"));
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
