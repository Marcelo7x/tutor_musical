import 'package:asp/asp.dart';
import 'package:flutter/material.dart';

import '../play_score_atom.dart';

class AndamentoWidget extends StatelessWidget {
  AndamentoWidget({super.key});
  final andamentoController =
      TextEditingController(text: andamento.value.toString());

  @override
  Widget build(BuildContext context) {
    context.select(() => [andamento]);

    return SizedBox(
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
              andamentoController.text = andamento.value.toInt().toString();
            },
            icon: Icon(
              Icons.remove,
              size: 50,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            andamento.value.toString(),
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontSize: 18,
                ),
          ),
          IconButton(
            onPressed: () {
              if (andamento.value >= 300) return;
              andamento.value++;
              andamentoController.text = andamento.value.toInt().toString();
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
