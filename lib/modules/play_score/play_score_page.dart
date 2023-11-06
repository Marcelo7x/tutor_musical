import 'package:asp/asp.dart';
import 'package:flutter/material.dart';
import 'package:tutor_musical/modules/play_score/play_score_atom.dart';
import 'package:tutor_musical/modules/share/score_element.dart';

class PlayScorePage extends StatefulWidget {
  const PlayScorePage({super.key});

  @override
  State<PlayScorePage> createState() => _PlayScorePageState();
}

class _PlayScorePageState extends State<PlayScorePage> {
  @override
  void initState() {
    setState(() {
      scoreParser.call();
      buildScore.call();

      // colorChangeStreams = scoreHandler.value!.elements
      //     .map((e) => Stream<int>.periodic(
      //         Duration(milliseconds: (e.initTime * 1000).toInt()), (j) => j))
      //     .toList();
    });
  }

  final andamentoController =
      TextEditingController(text: andamento.value.toString());
  ScrollController controller = ScrollController();
  int? coloredIndex;

  // List<Stream<int>> colorChangeStreams = [
  //   Stream<int>.periodic(const Duration(seconds: 1), (j) => j)
  // ];

  List<List<String>> acertos = [];

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

    context.select(() => [state, scoreState, recoderIsRunning, andamento]);

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
                // colorChangeStreams = scoreHandler.value!.elements
                //     .map((e) => Stream<int>.periodic(
                //         Duration(milliseconds: (e.initTime * 1000).toInt()),
                //         (j) => j))
                //     .toList();

                buildScore.call();

                // int countdownDuration = int.parse(scoreABC.value!.metro[0]);
                // double time = (60 / andamento.value * 4);

                // List<Stream<int>> cotagem = List.generate(
                //   countdownDuration,
                //   (index) => Stream<int>.periodic(
                //     Duration(milliseconds: (time * 1000).toInt()),
                //     (j) => j,
                //   ),
                // );

                double fontSize = 100;
                final countdownStream = Stream<int>.fromFutures([
                  Future.delayed(const Duration(milliseconds: 0), () => 4),
                  Future.delayed(
                      Duration(
                          milliseconds:
                              ((60 / andamento.value) * 1000).toInt()),
                      () => 3),
                  Future.delayed(
                      Duration(
                          milliseconds:
                              ((60 / andamento.value) * 1000).toInt() * 2),
                      () => 2),
                  Future.delayed(
                      Duration(
                          milliseconds:
                              ((60 / andamento.value) * 1000).toInt() * 3),
                      () => 1),
                  // Future.delayed(const Duration(milliseconds: 3900), () => 0),
                ]);

                recoderIsRunning.value = true;
                showDialog(
                  context: context,
                  barrierColor: Colors.transparent,
                  builder: (context) {
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      elevation: 0,
                      child: StreamBuilder<int>(
                        stream: countdownStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data == 1) {
                            WidgetsBinding.instance!
                                .addPostFrameCallback((timeStamp) async {
                              await Future.delayed(Duration(
                                  milliseconds:
                                      ((60 / andamento.value) * 1000).toInt()));
                              openRecoder.call();
                              playScore.call();
                              Navigator.pop(context);
                            });
                          }
                          if (snapshot.hasData) {
                            return Center(
                              child: Text(
                                snapshot.data!.toString(),
                                style: TextStyle(
                                  fontSize: 200,
                                  color: Theme.of(context).colorScheme.primary,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 1.5,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.5),
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    );
                  },
                );

                // openRecoder.call();
                // playScore.call();

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
                      if (andamento.value < 21) return;
                      andamento.value--;
                      andamentoController.text =
                          andamento.value.toInt().toString();
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
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        int v = int.parse(value.isNotEmpty ? value : '0');
                        if (v < 1) {
                          andamento.value = 1;
                        } else if (v >= 300) {
                          andamento.value = 300;
                        } else if (v >= 1) {
                          andamento.value = v;
                        }
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (andamento.value >= 300) return;
                      andamento.value++;
                      andamentoController.text =
                          andamento.value.toInt().toString();
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
                scoreABC.value?.title ?? '',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 34),
              ),
              Text(
                scoreABC.value?.composer ?? '',
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
                        stream: colorChangeStreams.value[i],
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
