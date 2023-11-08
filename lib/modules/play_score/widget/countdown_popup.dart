import 'package:flutter/material.dart';

import '../play_score_atom.dart';

class CountdownPopup extends StatelessWidget {
  const CountdownPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final countdownStream = Stream<int>.fromFutures([
      Future.delayed(const Duration(milliseconds: 0), () => 4),
      Future.delayed(
          Duration(milliseconds: ((60 / andamento.value) * 1000).toInt()),
          () => 3),
      Future.delayed(
          Duration(milliseconds: ((60 / andamento.value) * 1000).toInt() * 2),
          () => 2),
      Future.delayed(
          Duration(milliseconds: ((60 / andamento.value) * 1000).toInt() * 3),
          () => 1),
    ]);

    return Dialog(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      child: StreamBuilder<int>(
        stream: countdownStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == 1) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
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
  }
}
