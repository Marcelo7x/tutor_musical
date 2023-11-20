import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tutor_musical/modules/share/abc_parser.dart';

abstract class ScoreElement {
  final dynamic el;
  final double topPadding;
  final double bottomPadding;
  final double length;
  final double initTime;
  double _relativeWidth = 0.25;
  double _relativeHeight = 1;

  ScoreElement({
    required this.el,
    required this.topPadding,
    required this.bottomPadding,
    required this.length,
    required this.initTime,
  });

  Widget build(context, {required double spaceSize, color});
}

class NoteScoreElement extends ScoreElement {
  final ABCNote note;
  bool? rangRight = null;
  NoteScoreElement({
    required this.note,
    required dynamic el,
    required double topPadding,
    required double bottomPadding,
    required double length,
    required double initTime,
  }) : super(
            el: el,
            topPadding: topPadding,
            bottomPadding: bottomPadding,
            length: length,
            initTime: initTime) {
    _relativeWidth = 1;
    _relativeHeight = 1;
  }

  @override
  Widget build(context, {required double spaceSize, color}) {
    return SizedBox(
      height: 15 * spaceSize,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '\ue01a',
            style: TextStyle(
              fontFamily: 'Bravura',
              fontSize: 5 * spaceSize,
              color: Theme.of(context).colorScheme.onBackground,
              fontFeatures: const [
                FontFeature.enable('liga'),
              ],
            ),
          ),
          if (bottomPadding >= 6 * spaceSize - 1)
            Padding(
              padding: EdgeInsets.only(
                bottom: (bottomPadding / spaceSize) % 2 == 0
                    ? bottomPadding - (4 * spaceSize)
                    : bottomPadding - (5 * spaceSize),
              ),
              child: Text(
                '\ue01a',
                style: TextStyle(
                  fontFamily: 'Bravura',
                  fontSize: 5 * spaceSize,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontFeatures: const [
                    FontFeature.enable('liga'),
                  ],
                ),
              ),
            ),
            if (topPadding >= 6 * spaceSize - 1)
            Padding(
              padding: EdgeInsets.only(
                top: (topPadding / spaceSize) % 2 == 0
                    ? topPadding - (4 * spaceSize)
                    : topPadding - (5 * spaceSize),
              ),
              child: Text(
                '\ue01a',
                style: TextStyle(
                  fontFamily: 'Bravura',
                  fontSize: 5 * spaceSize,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontFeatures: const [
                    FontFeature.enable('liga'),
                  ],
                ),
              ),
            ),
          if (note.accident != null)
            Padding(
              padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
              child: Text(
                ' ' + el[0],
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
          Text(
            ' \ue01a',
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
            // * nota com acidente
            padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
            child: Text(
              el is List ? ' ' + el[1] : ' ' + el,
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
          Text(
            '\ue020 ',
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

class PauseScoreElement extends ScoreElement {
  ABCPause pause;
  PauseScoreElement({
    required this.pause,
    required dynamic el,
    required double topPadding,
    required double bottomPadding,
    required double length,
    required double initTime,
  }) : super(
            el: el,
            topPadding: topPadding,
            bottomPadding: bottomPadding,
            length: length,
            initTime: initTime) {
    _relativeWidth = 1;
    _relativeHeight = 1;
  }

  @override
  Widget build(context, {required double spaceSize, color}) {
    return SizedBox(
      height: 15 * spaceSize,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '\ue01a',
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
            padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
            child: Text(
              ' ' + el,
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
  }
}

class ToneScoreElement extends ScoreElement {
  ToneScoreElement({
    required dynamic el,
    required double topPadding,
    required double bottomPadding,
    required double length,
    required double initTime,
  }) : super(
            el: el,
            topPadding: topPadding,
            bottomPadding: bottomPadding,
            length: length,
            initTime: initTime) {
    _relativeWidth = 1;
    _relativeHeight = 1;
  }

  @override
  Widget build(context, {required double spaceSize, color}) {
    return SizedBox(
      // alignment: Alignment.center,
      // color: color != null ? Colors.blue : Colors.transparent,
      // width: spaceSize * 5,
      height: 15 * spaceSize,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
            child: Text(
              el + ' ',
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
  }
}

class CompasseSeparatorScoreElement extends ScoreElement {
  CompasseSeparatorScoreElement({
    required dynamic el,
    required double topPadding,
    required double bottomPadding,
    required double length,
    required double initTime,
  }) : super(
            el: el,
            topPadding: topPadding,
            bottomPadding: bottomPadding,
            length: length,
            initTime: initTime) {
    _relativeWidth = 1;
    _relativeHeight = 1;
  }

  @override
  Widget build(context, {required double spaceSize, color}) {
    return SizedBox(
      // alignment: Alignment.center,
      // color: color != null ? Colors.pink : Colors.transparent,
      // width: spaceSize,
      height: 15 * spaceSize,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
            child: Text(
              ' ${el}',
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
  }
}

class BarlineScoreElement extends ScoreElement {
  BarlineScoreElement({
    required dynamic el,
    required double topPadding,
    required double bottomPadding,
    required double length,
    required double initTime,
  }) : super(
            el: el,
            topPadding: topPadding,
            bottomPadding: bottomPadding,
            length: length,
            initTime: initTime) {
    _relativeWidth = 1;
    _relativeHeight = 1;
  }

  @override
  Widget build(context, {required double spaceSize, color}) {
    return SizedBox(
      height: 15 * spaceSize,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
            child: Text(
              '$el',
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
  }
}

class LengthScoreElement extends ScoreElement {
  LengthScoreElement({
    required dynamic el,
    required double topPadding,
    required double bottomPadding,
    required double length,
    required double initTime,
  }) : super(
            el: el,
            topPadding: topPadding,
            bottomPadding: bottomPadding,
            length: length,
            initTime: initTime) {
    _relativeWidth = 1;
    _relativeHeight = 1;
  }

  @override
  Widget build(context, {required double spaceSize, color}) {
    return SizedBox(
      // alignment: Alignment.center,
      // color: color != null ? Colors.green : Colors.transparent,
      // width: spaceSize,
      height: 15 * spaceSize,
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
            padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
            child: Text(
              el + '  ',
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
  }
}

class CompasseLengthElement extends ScoreElement {
  CompasseLengthElement({
    required dynamic el,
    required double topPadding,
    required double bottomPadding,
    required double length,
    required double initTime,
  }) : super(
            el: el,
            topPadding: topPadding,
            bottomPadding: bottomPadding,
            length: length,
            initTime: initTime) {
    _relativeWidth = 1;
    _relativeHeight = 1;
  }

  @override
  Widget build(context, {required double spaceSize, color}) {
    return SizedBox(
      // alignment: Alignment.center,
      // color: color != null ? Colors.blue : Colors.transparent,
      // width: spaceSize * 2.2,
      height: 15 * spaceSize,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
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
            padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
            child: Text(
              el,
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
  }
}

class LigadureScoreElement extends ScoreElement {
  LigadureScoreElement({
    required dynamic el,
    required double topPadding,
    required double bottomPadding,
    required double length,
    required double initTime,
  }) : super(
            el: el,
            topPadding: topPadding,
            bottomPadding: bottomPadding,
            length: length,
            initTime: initTime) {
    _relativeWidth = 1;
    _relativeHeight = 1;
  }

  @override
  Widget build(context, {required double spaceSize, color}) {
    return SizedBox(
      height: 15 * spaceSize,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
            child: Text(
              el,
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
          Text(
            '\ue02a',
            style: TextStyle(
              fontFamily: 'Bravura',
              fontSize: 5 * spaceSize,
              color: color ?? Theme.of(context).colorScheme.onBackground,
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
