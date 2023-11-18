import 'package:asp/asp.dart';
import 'package:flutter/material.dart';

import '../play_score_atom.dart';

class InstrumentTuring extends StatelessWidget {
  const InstrumentTuring({super.key});

  @override
  Widget build(BuildContext context) {
    context.select(() => [turingInstrument]);
    return SizedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Afinação:  ',
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontSize: 18,
                ),
          ),
          DropdownButton<TuringInstrument>(
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontSize: 18,
                ),
            elevation: 10,
            value: turingInstrument.value,
            items: TuringInstrument.values
                .map((e) => DropdownMenuItem<TuringInstrument>(
                      value: e,
                      child: Text(
                        e.interval.keys.first,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontSize: 18,
                            ),
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              turingInstrument.value = value ?? TuringInstrument.c;
            },
          ),
        ],
      ),
    );
  }
}
