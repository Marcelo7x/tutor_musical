import 'dart:io';

import 'package:asp/asp.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../home_atoms.dart';

class ScoresPage extends StatefulWidget {
  const ScoresPage({super.key});

  @override
  State<ScoresPage> createState() => _ScoresPageState();
}

class _ScoresPageState extends State<ScoresPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    context.select(() => [scores, loading]);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: !loading.value
            ? Column(
                children: [
                  Wrap(
                    children: [
                      for (MapEntry s in scores.value)
                        Card(
                          child: SizedBox(
                            height: 200,
                            width: 150,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(0),
                              ),
                              onPressed: () async {
                                Modular.to.pushNamed('/play/', arguments: s.value);
                              },
                              child: SizedBox(
                                height: 200,
                                child: Stack(
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    const Center(
                                      child: Icon(
                                        Icons.music_note_rounded,
                                        size: 50,
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      width: 150,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.3),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        s.key.substring(
                                            0, s.key.lastIndexOf('.')),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .copyWith(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      Card(
                        child: SizedBox(
                          height: 200,
                          width: 150,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(0),
                            ),
                            onPressed: () async {
                              addScore();
                            },
                            child: const Center(
                              child: Icon(
                                Icons.add_rounded,
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
