import 'package:asp/asp.dart';
import 'package:flutter/material.dart';

import '../play_score_atom.dart';

class ZoomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.select(() => [spaceSize]);

    return SizedBox(
      width: 300,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (spaceSize.value <= 5) return;
              spaceSize.value -= 5;
              buildScore.call();
            },
            icon: Icon(
              Icons.remove,
              size: 50,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            'Zoom',
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontSize: 18,
                ),
          ),
          IconButton(
            onPressed: () {
              if (spaceSize.value >= 50) return;
              spaceSize.value += 5;
              buildScore.call();
            },
            icon: Icon(
              Icons.add,
              size: 50,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
