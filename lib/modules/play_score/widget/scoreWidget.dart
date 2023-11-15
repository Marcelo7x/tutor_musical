import 'package:asp/asp.dart';
import 'package:flutter/material.dart';

import '../../share/score_element.dart';
import '../play_score_atom.dart';

class ScoreWidget extends StatefulWidget {
  const ScoreWidget({super.key});

  @override
  State<ScoreWidget> createState() => _ScoreWidgetState();
}

class _ScoreWidgetState extends State<ScoreWidget> {
  int? coloredIndex;

  @override
  Widget build(BuildContext context) {
    context.select(() =>
        [state, scoreState, recoderIsRunning, andamento, turingInstrument]);

    return Column(
      children: [
        Text(
          scoreABC.value?.title ?? '',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 34),
        ),
        Text(
          scoreABC.value?.composer ?? '',
          style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 50),
        Wrap(
          spacing: 0,
          children: [
            if (scoreState.value is PlayingScoreState)
              for (int i = 0; i < scoreHandler.value!.elements.length; i++)
                StreamBuilder<int>(
                  stream: colorChangeStreams.value[i],
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        scoreHandler.value!.elements[i].length != 0) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        setState(() {
                          coloredIndex = i;
                        });
                      });
                    }

                    if (snapshot.hasData &&
                        i == scoreHandler.value!.elements.length - 1) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        scoreState.value = ViewScoreState();
                      });
                    }

                    return scoreHandler.value!.elements[i].build(context,
                        spaceSize: spaceSize.value,
                        color: i == coloredIndex
                            ? Theme.of(context).colorScheme.primary
                            : null);
                  },
                ),
            if (scoreState.value is ViewScoreState)
              for (int i = 0; i < scoreHandler.value!.elements.length; i++)
                scoreHandler.value!.elements[i]
                    .build(context, spaceSize: spaceSize.value),
            if (scoreState.value is ResultScoreState)
              for (int i = 0; i < scoreHandler.value!.elements.length; i++)
                scoreHandler.value!.elements[i].build(
                  context,
                  spaceSize: spaceSize.value,
                  color: scoreHandler.value!.elements[i] is NoteScoreElement
                      ? (scoreHandler.value!.elements[i] as NoteScoreElement)
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
    );
  }
}
