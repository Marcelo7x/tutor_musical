import 'package:asp/asp.dart';
import 'package:flutter/material.dart';
import 'package:tutor_musical/modules/play_score/play_score_atom.dart';
import 'package:tutor_musical/modules/play_score/widget/andamento_widget.dart';
import 'package:tutor_musical/modules/play_score/widget/countdown_popup.dart';
import 'package:tutor_musical/modules/play_score/widget/instrument_turing_widget.dart';
import 'package:tutor_musical/modules/play_score/widget/scoreWidget.dart';
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
    });
  }

  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    final availableHeight = MediaQuery.sizeOf(context).height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    context.select(() =>
        [state, scoreState, recoderIsRunning, andamento, turingInstrument]);

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
                buildScore.call();
                openRecoder.call();
                playScore.call();
                // await scoreState.next();
                // showDialog(
                //   context: context,
                //   barrierColor: Colors.transparent,
                //   builder: (context) {
                //     return const CountdownPopup();
                //   },
                // );

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
            AndamentoWidget(),
            const SizedBox(
              width: 10,
            ),
            const InstrumentTuring(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          // height: availableHeight,
          width: width,
          padding: const EdgeInsets.all(20),
          child: const ScoreWidget(),
        ),
      ),
    );
  }
}
