import 'package:asp/asp.dart';
import 'package:flutter/material.dart';
import 'package:tutor_musical/modules/play_score/play_score_atom.dart';
import 'package:tutor_musical/modules/share/abc/abc_parser.dart';
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
      scoreHandler.value = ScoreElementHandler(
        scoreElements: score!,
        spaceSize: 25,
        lastLength: length,
        // initTime: initTime,
        andamento: andamento,
      );

      colorChangeStreams = scoreHandler.value!.elements
          .map((e) => Stream<int>.periodic(
              Duration(milliseconds: (e.initTime * 1000).toInt()), (j) => j))
          .toList();
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

  // ScoreElementHandler? handler;
  List<Stream<int>> colorChangeStreams = [
    Stream<int>.periodic(const Duration(seconds: 1), (j) => j)
  ];

  List<List<String>> acertos = [];

  // final rec = Recoder();
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

    context.select(() => [
          state,
          scoreState,
          recoderIsRunning,
        ]);

    if (state.value is LoadingPlayScoreState) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (state.value is ErrorPlayScoreState) {
      return Scaffold(
        body: Center(
          child: Text((state.value as ErrorPlayScoreState).message),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              onPressed: () async {
                colorChangeStreams = scoreHandler.value!.elements
                    .map((e) => Stream<int>.periodic(
                        Duration(milliseconds: (e.initTime * 1000).toInt()),
                        (j) => j))
                    .toList();

                countdownDuration = 2;

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

                openRecoder.call();
                playScore.call();

                while (recoderIsRunning.value) {
                  await Future.delayed(const Duration(milliseconds: 500));
                }

                processUserPerformace.call();
              },
              icon: Icon(
                Icons.play_arrow_outlined,
                size: 50,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            IconButton(
              onPressed: () {},
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
                        scoreHandler.value = ScoreElementHandler(
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
                          scoreHandler.value = ScoreElementHandler(
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
                        scoreHandler.value = ScoreElementHandler(
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
                  if (scoreState.value is PlayingScoreState)
                    for (int i = 0;
                        i < scoreHandler.value!.elements.length;
                        i++)
                      StreamBuilder<int>(
                        stream: colorChangeStreams[i],
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              scoreHandler.value!.elements[i].length != 0) {
                            WidgetsBinding.instance
                                .addPostFrameCallback((timeStamp) {
                              setState(() {
                                coloredIndex = i;
                              });
                            });
                          }

                          if (snapshot.hasData &&
                              i == scoreHandler.value!.elements.length - 1) {
                            WidgetsBinding.instance
                                .addPostFrameCallback((timeStamp) {
                              scoreState.value = ViewScoreState();
                            });
                          }

                          return scoreHandler.value!.elements[i].build(context,
                              spaceSize: spaceSize,
                              color: i == coloredIndex
                                  ? Theme.of(context).colorScheme.primary
                                  : null);
                        },
                      ),
                  if (scoreState.value is ViewScoreState)
                    for (int i = 0;
                        i < scoreHandler.value!.elements.length;
                        i++)
                      scoreHandler.value!.elements[i]
                          .build(context, spaceSize: spaceSize),
                  if (scoreState.value is ResultScoreState)
                    for (int i = 0;
                        i < scoreHandler.value!.elements.length;
                        i++)
                      scoreHandler.value!.elements[i].build(
                        context,
                        spaceSize: spaceSize,
                        color:
                            scoreHandler.value!.elements[i] is NoteScoreElement
                                ? (scoreHandler.value!.elements[i]
                                                    as NoteScoreElement)
                                                .rangRight !=
                                            null &&
                                        (scoreHandler.value!.elements[i]
                                                as NoteScoreElement)
                                            .rangRight!
                                    ? Colors.green
                                    : Colors.red
                                : null,
                      ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
