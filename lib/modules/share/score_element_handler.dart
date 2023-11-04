import 'dart:ui';

import 'package:flutter/material.dart';
import 'abc/abc_parser.dart';
import 'score_element.dart';

class ScoreElementHandler {
  final double spaceSize;
  double lastLength;
  final List<double> initTime = [0];
  final double andamento;
  final List<ScoreElement> elements = [];

  ScoreElementHandler({
    required ABCMusic scoreElements,
    required this.spaceSize,
    required this.lastLength,
    // required this.initTime,
    required this.andamento,
  }) {
    for (var el in scoreElements.elements) {
      elements.add(handleElement(el));
      if (elements.last is ToneScoreElement) {
        elements.add(handleCompasseLength(
            int.parse(scoreElements.metro.substring(0, 1)),
            int.parse(scoreElements.metro.substring(2))));
      }
    }
  }

  ScoreElement handleElement(dynamic el) {
    if (el is ABCTone) {
      return handleABCTone();
    } else if (el is ABCNote) {
      return handleABCNote(el);
    } else if (el is ABCPause) {
      return handleABCPause(el);
    } else if (el is ABCCompasseSeparator) {
      return handleABCCompasseSeparator();
    } else if (el is ABCLength) {
      return handleABCLength(el);
    } else {
      throw Exception('Invalid element type or not implemented');
    }
  }

  CompasseLengthElement handleCompasseLength(int num, int div) {
    String s = '';
    switch (num) {
      case 1:
        s = '\ue081';
      case 2:
        s = '\uE08B';
      case 3:
        s = '\uE099';
      case 4:
        s = '\uE08A';

      default:
        s = '\ue084';
    }

    // s += '\ue08e';

    // switch (div) {
    //   case 1:
    //     s += '\ue081';
    //   case 2:
    //     s += '\ue082';
    //   case 3:
    //     s += '\ue093';
    //   case 4:
    //     s += '\uE09F\uE084';

    //   default:
    //     s += '\ue084';
    // }

    return CompasseLengthElement(
      el: s,
      topPadding: 0,
      bottomPadding: 4 * spaceSize,
      length: 0,
      initTime: initTime.last,
    );
  }

  ToneScoreElement handleABCTone() {
    String s = '\ue01a\ue050\ue01a';
    return ToneScoreElement(
      el: s,
      topPadding: 0,
      bottomPadding: 0,
      length: 0,
      initTime: initTime.last,
    );
  }

  NoteScoreElement handleABCNote(ABCNote el) {
    String note = '';
    double topPadding = 0;
    double bottomPadding = 0;

    switch (el.note) {
      case 'A':
        topPadding = spaceSize;

      case 'B':
        topPadding = 0;

      case 'C':
        topPadding = 6 * spaceSize;

      case 'D':
        topPadding = 5 * spaceSize;

      case 'E':
        topPadding = 4 * spaceSize;

      case 'F':
        topPadding = 3 * spaceSize;

      case 'G':
        topPadding = 2 * spaceSize;

      case 'a':
        bottomPadding = 6 * spaceSize;

      case 'b':
        bottomPadding = 7 * spaceSize;

      case 'c':
        bottomPadding = 1 * spaceSize;
      case 'd':
        bottomPadding = 2 * spaceSize;

      case 'e':
        bottomPadding = 3 * spaceSize;

      case 'f':
        bottomPadding = 4 * spaceSize;

      case 'g':
        bottomPadding = 5 * spaceSize;
    }

    double n = lastLength;
    if (el.duration != null && el.duration!.isNotEmpty) {
      for (var e in el.duration!) {
        n = e.isMult ? n * 2 : n / 2;
      }
      // print(n);
    }
    switch (n) {
      case 4:
        note = '\uE1D2-';
        if (initTime.isNotEmpty) {
          initTime.add(initTime.last + (60 / andamento * 4));
        }
      case 2:
        note = '\uE1D3-';
        if (initTime.isNotEmpty) {
          initTime.add(initTime.last + (60 / andamento * 2));
        }
      case 1:
        note = '\uE1D5-';
        if (initTime.isNotEmpty) {
          initTime.add(initTime.last + (60 / andamento * 1));
        }
      case 0.5:
        note = '\uE1D7';
        if (initTime.isNotEmpty) {
          initTime.add(initTime.last + (60 / andamento * 0.5));
        }
      case 0.25:
        note = '\uE1D9';
        if (initTime.isNotEmpty) {
          initTime.add(initTime.last + (60 / andamento * 0.25));
        }
    }

    // s = note;
    return NoteScoreElement(
      note: el,
      el: note,
      topPadding: topPadding,
      bottomPadding: bottomPadding,
      length: n,
      initTime: initTime[initTime.length - 2],
    );
  }

  PauseScoreElement handleABCPause(ABCPause el) {
    String pause = '';
    double n = lastLength;
    if (el.duration != null && el.duration!.isNotEmpty) {
      for (var e in el.duration!) {
        n = e.isMult ? n * 2 : n / 2;
      }
      // print(n);
    }
    switch (n) {
      case 4:
        pause = '\uE4E3-';
        if (initTime.isNotEmpty) {
          initTime.add(initTime.last + (60 / andamento * 4));
        }
      case 2:
        pause = '\uE4E4-';
        if (initTime.isNotEmpty) {
          initTime.add(initTime.last + (60 / andamento * 2));
        }
      case 1:
        pause = '\uE4E5-';
        if (initTime.isNotEmpty) {
          initTime.add(initTime.last + (60 / andamento * 1));
        }
      case 0.5:
        pause = '\uE4E6-';
        if (initTime.isNotEmpty) {
          initTime.add(initTime.last + (60 / andamento * 0.5));
        }
      case 0.25:
        pause = '\uE4E7-';
        if (initTime.isNotEmpty) {
          initTime.add(initTime.last + (60 / andamento * 0.25));
        }
    }

    return PauseScoreElement(
      pause: el,
      el: pause,
      topPadding: 0,
      bottomPadding: 0,
      length: n,
      initTime: initTime[initTime.length - 2],
    );
  }

  CompasseSeparatorScoreElement handleABCCompasseSeparator() {
    String s = '\ue030';
    return CompasseSeparatorScoreElement(
      el: s,
      topPadding: 0,
      bottomPadding: 0,
      length: 0,
      initTime: initTime.last,
    );
  }

  LengthScoreElement handleABCLength(ABCLength el) {
    lastLength = 4 * el.length; // length = 1/4 ==> 1/4 de semibreve
    return LengthScoreElement(
        el: '',
        topPadding: 0,
        bottomPadding: 0,
        length: 0,
        initTime: initTime.last);
  }

  List<Widget> buildScore(context) {
    return elements.map((e) => buildRow(context, e)).toList();
  }

  Widget buildRow(context, ScoreElement element, {color}) {
    if (element is NoteScoreElement) {
      return Container(
        color: color != null ? Colors.amber : Colors.transparent,
        width: 70,
        height: 15 * spaceSize,
        child: Row(
          children: [
            Text(
              '\ue020\ue01a',
              style: TextStyle(
                fontFamily: 'Bravura',
                fontSize: 5 * spaceSize,
                color: Theme.of(context).colorScheme.onBackground,
                fontFeatures: const [
                  FontFeature.enable('liga'),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: element.topPadding, bottom: element.bottomPadding),
              child: Text(
                element.el,
                style: TextStyle(
                  fontFamily: 'Bravura',
                  fontSize: 5 * spaceSize,
                  color: color ?? Theme.of(context).colorScheme.onBackground,
                  fontFeatures: const [
                    FontFeature.enable('liga'),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else if (element is PauseScoreElement) {
      return Container(
        color: color != null ? Colors.orange : Colors.transparent,
        width: spaceSize * 2.2,
        height: 15 * spaceSize,
        child: Row(
          children: [
            Text(
              '\ue020\ue01a',
              style: TextStyle(
                fontFamily: 'Bravura',
                fontSize: 5 * spaceSize,
                color: Theme.of(context).colorScheme.onBackground,
                fontFeatures: const [
                  FontFeature.enable('liga'),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: element.topPadding, bottom: element.bottomPadding),
              child: Text(
                element.el,
                style: TextStyle(
                  fontFamily: 'Bravura',
                  fontSize: 5 * spaceSize,
                  color: color ?? Theme.of(context).colorScheme.onBackground,
                  fontFeatures: const [
                    FontFeature.enable('liga'),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else if (element is CompasseSeparatorScoreElement) {
      return Container(
        color: color != null ? Colors.pink : Colors.transparent,
        width: spaceSize * 2.2,
        height: 15 * spaceSize,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: element.topPadding, bottom: element.bottomPadding),
              child: Text(
                '\ue01a' + element.el,
                style: TextStyle(
                  fontFamily: 'Bravura',
                  fontSize: 5 * spaceSize,
                  color: color ?? Theme.of(context).colorScheme.onBackground,
                  fontFeatures: const [
                    FontFeature.enable('liga'),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else if (element is LengthScoreElement) {
      return Container(
        color: color != null ? Colors.green : Colors.transparent,
        width: spaceSize,
        height: 15 * spaceSize,
        child: Row(
          children: [
            Text(
              '\ue020',
              style: TextStyle(
                fontFamily: 'Bravura',
                fontSize: 5 * spaceSize,
                color: Theme.of(context).colorScheme.onBackground,
                fontFeatures: const [
                  FontFeature.enable('liga'),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: element.topPadding, bottom: element.bottomPadding),
              child: Text(
                element.el,
                style: TextStyle(
                  fontFamily: 'Bravura',
                  fontSize: 5 * spaceSize,
                  color: color ?? Theme.of(context).colorScheme.onBackground,
                  fontFeatures: const [
                    FontFeature.enable('liga'),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else if (element is ToneScoreElement) {
      return Container(
        color: color != null ? Colors.blue : Colors.transparent,
        width: spaceSize * 5,
        height: 15 * spaceSize,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: element.topPadding, bottom: element.bottomPadding),
              child: Text(
                element.el,
                style: TextStyle(
                  fontFamily: 'Bravura',
                  fontSize: 5 * spaceSize,
                  color: color ?? Theme.of(context).colorScheme.onBackground,
                  fontFeatures: const [
                    FontFeature.enable('liga'),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else if (element is CompasseLengthElement) {
      return Container(
        color: color != null ? Colors.blue : Colors.transparent,
        width: spaceSize * 2.2,
        height: 15 * spaceSize,
        child: Row(
          children: [
            Text(
              '\ue01a',
              style: TextStyle(
                fontFamily: 'Bravura',
                fontSize: 5 * spaceSize,
                color: color ?? Theme.of(context).colorScheme.onBackground,
                fontFeatures: const [
                  FontFeature.enable('liga'),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: element.topPadding, bottom: element.bottomPadding),
              child: Text(
                element.el,
                style: TextStyle(
                  fontFamily: 'Bravura',
                  fontSize: 5 * spaceSize,
                  color: color ?? Theme.of(context).colorScheme.onBackground,
                  fontFeatures: const [
                    FontFeature.enable('liga'),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      throw Exception('Invalid element type or not implemented');
    }
  }
}
