import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tutor_musical/modules/share/score_builder.dart';

import 'abc/abc_parser.dart';

class _Element {
  final dynamic el;
  final double topPadding;
  final double bottomPadding;
  final double length;
  final double initTime;

  _Element({
    required this.el,
    required this.topPadding,
    required this.bottomPadding,
    required this.length,
    required this.initTime,
  });
}

class ScoreElementHandler {
  final double spaceSize;
  double lastLength;
  final List<double> initTime = [0];
  final double andamento;
  final List<_Element> elements = [];

  ScoreElementHandler({
    required ABCMusic scoreElements,
    required this.spaceSize,
    required this.lastLength,
    // required this.initTime,
    required this.andamento,
  }) {
    for (var el in scoreElements.elements) {
      elements.add(handleElement(el));
    }
  }

  _Element handleElement(dynamic el) {
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
    }

    return _Element(
      el: '',
      topPadding: 0,
      bottomPadding: 0,
      length: -1,
      initTime: -1,
    );
  }

  _Element handleABCTone() {
    String s = '\ue050\ue01a-\ue01a-\ue01a-';
    return _Element(
      el: s,
      topPadding: 0,
      bottomPadding: 0,
      length: 0,
      initTime: initTime.last,
    );
  }

  _Element handleABCNote(ABCNote el) {
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
          initTime.add(initTime.last + (60/andamento * 4));
        }
      case 2:
        note = '\uE1D3-';
        if (initTime.isNotEmpty) {
          initTime.add(initTime.last + (60/andamento * 2));
        }
      case 1:
        note = '\uE1D5-';
        if (initTime.isNotEmpty) {
          initTime.add(initTime.last + (60/andamento * 1));
        }
      case 0.5:
        note = '\uE1D7';
        if (initTime.isNotEmpty) {
          initTime.add(initTime.last + (60/andamento * 0.5));
        }
      case 0.25:
        note = '\uE1D9';
        if (initTime.isNotEmpty) {
          initTime.add(initTime.last + (60/andamento * 0.25));
        }
    }

    // s = note;
    return _Element(
      el: note,
      topPadding: topPadding,
      bottomPadding: bottomPadding,
      length: n,
      initTime: initTime[initTime.length - 2],
    );
  }

  _Element handleABCPause(ABCPause el) {
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
          initTime.add(initTime.last + (60/andamento * 4));
        }
      case 2:
        pause = '\uE4E4-';
        if (initTime.isNotEmpty) {
          initTime.add(initTime.last + (60/andamento * 2));
        }
      case 1:
        pause = '\uE4E5-';
        if (initTime.isNotEmpty) {
          initTime.add(initTime.last + (60/andamento * 1));
        }
      case 0.5:
        pause = '\uE4E6-';
        if (initTime.isNotEmpty) {
          initTime.add(initTime.last + (60/andamento * 0.5));
        }
      case 0.25:
        pause = '\uE4E7-';
        if (initTime.isNotEmpty) {
          initTime.add(initTime.last + (60/andamento * 0.25));
        }
    }

    return _Element(
      el: pause,
      topPadding: 0,
      bottomPadding: 0,
      length: n,
      initTime: initTime[initTime.length - 2],
    );
  }

  _Element handleABCCompasseSeparator() {
    String s = '\ue030-';
    return _Element(
      el: s,
      topPadding: 0,
      bottomPadding: 0,
      length: 0,
      initTime: initTime.last,
    );
  }

  _Element handleABCLength(ABCLength el) {
    lastLength = 4 * el.length; // length = 1/4 ==> 1/4 de semibreve
    return _Element(
        el: '', topPadding: 0, bottomPadding: 0, length: 0, initTime: initTime.last);
  }

  List<Widget> buildScore(context) {
    return elements.map((e) => buildRow(context, e)).toList();
  }

  Widget buildRow(context, _Element element, {color}) {
    return SizedBox(
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
                color: color?? Theme.of(context).colorScheme.onBackground,
                fontFeatures: const [
                  FontFeature.enable('liga'),
                ],
              ),
            ),
          ),
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
        ],
      ),
    );
  }
}
