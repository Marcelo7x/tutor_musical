import 'package:asp/asp.dart';
import 'package:flutter/material.dart';

import '../../app_atom.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    context.select(() => [theme]);
    return Scaffold(
      body: Container(
        width: width,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Dark Theme",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(fontSize: 16),
                ),
                Switch(
                  value: theme.value == ThemeMode.dark,
                  onChanged: (value) => switchTheme(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
