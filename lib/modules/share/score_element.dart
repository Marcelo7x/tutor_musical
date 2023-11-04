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
}

class NoteScoreElement extends ScoreElement {
  NoteScoreElement({
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
}

class PauseScoreElement extends ScoreElement {
  PauseScoreElement({
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
}