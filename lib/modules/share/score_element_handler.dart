import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tutor_musical/modules/share/smufl_specification/glyphnames.dart';
import 'abc_parser.dart';
import 'score_element.dart';

class ScoreElementHandler {
  final double spaceSize;
  double lastLength;
  final List<double> initTime = [0];
  final int andamento;
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
    elements.removeLast();
    elements.add(handleABCCompasseSeparator(type: 'barlineFinal'));
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
    } else if (el is ABCLigadure) {
      return handleABCLigadure();
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
        note = '\uE1D2';
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
    String? accident;
    if (el.accident != null) {
      switch (el.accident) {
        case '^':
          accident = '\uE262';
          break;
        case '=':
          accident = '\uE261';
          break;
        case '_':
          accident = '\uE260';
          break;
      }
    }

    return NoteScoreElement(
      note: el,
      el: accident != null ? [accident, note] : note,
      topPadding: topPadding,
      bottomPadding: bottomPadding,
      length: n * 60 / andamento,
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

  BarlineScoreElement handleABCCompasseSeparator({String? type}) {
    String s = '\ue030';
    if (type != null && type.isNotEmpty) {
      s += glyphnames[type]?['codepoint'] ?? '\ue030';
    }
    return BarlineScoreElement(
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

  LigadureScoreElement handleABCLigadure() {
    return LigadureScoreElement(
        el: '', //!-
        topPadding: elements.last.topPadding,
        bottomPadding: elements.last.bottomPadding,
        length: 0,
        initTime: initTime.last);
  }

  // List<Widget> buildScore(context) {
  //   return elements.map((e) => buildRow(context, e)).toList();
  // }
}
