import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tutor_musical/modules/share/abc/abc_parser.dart';

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
    return Container(
      alignment: Alignment.center,
      // color: color != null ? Colors.amber : Colors.transparent,
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
    return Container(
      alignment: Alignment.center,
      // color: color != null ? Colors.orange : Colors.transparent,
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
    return Container(
      alignment: Alignment.center,
      // color: color != null ? Colors.blue : Colors.transparent,
      width: spaceSize * 5,
      height: 15 * spaceSize,
      child: Padding(
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
    return Container(
      alignment: Alignment.centerLeft,
      // color: color != null ? Colors.pink : Colors.transparent,
      width: spaceSize,
      height: 15 * spaceSize,
      child: Padding(
        padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
        child: Text(
          '\ue01a${el}',
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
    return Container(
      alignment: Alignment.center,
      // color: color != null ? Colors.green : Colors.transparent,
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
    return Container(
      alignment: Alignment.center,
      // color: color != null ? Colors.blue : Colors.transparent,
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
