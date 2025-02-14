//atoms
import 'package:asp/asp.dart';
import 'package:tutor_musical/modules/share/score_element_handler.dart';

import '../share/abc_parser.dart';
import '../share/ffi/rec_c++.dart';

final state = Atom<PlayScoreState>(ReadyPlayScoreState());
final scoreState = Atom<ScoreState>(ViewScoreState());
final recoderIsRunning = Atom<bool>(false);
final recoder = Atom<Recoder>(Recoder());
final andamento = Atom<int>(90);
final turingInstrument = Atom<TuringInstrument>(TuringInstrument.c);
final scoreABC = Atom<ABCMusic?>(null);
final spaceSize = Atom<double>(25);
final colorChangeStreams = Atom<List<Stream<int>>>([]);

//actions
final setError = Atom<String?>(null);
final openRecoder = Atom.action();
final closeRecoder = Atom.action();
final processUserPerformace = Atom.action();
final playScore = Atom.action();
final stopScore = Atom.action();
final scoreHandler = Atom<ScoreElementHandler?>(null);
final scoreParser = Atom.action();
final buildScore = Atom.action();

abstract class PlayScoreError {
  final String message;
  const PlayScoreError(this.message);
}

class PlayScoreState {}

class LoadingPlayScoreState extends PlayScoreState {}

class ReadyPlayScoreState extends PlayScoreState {}

class ErrorPlayScoreState extends PlayScoreState {
  final message;
  ErrorPlayScoreState(this.message);
}

class ScoreState {}

class ViewScoreState extends ScoreState {}

class PlayingScoreState extends ScoreState {}

class ResultScoreState extends ScoreState {}

class CountdownScoreState extends ScoreState {}

enum TuringInstrument {
  c({'C': 0}),
  cSus({'C#': 1}),
  d({'D': 2}),
  dSus({'D#': 3}),
  e({'E': 4}),
  f({'F': 5}),
  fSus({'F#': 6}),
  g({'G': 7}),
  gSus({'G#': 8}),
  a({'A': 9}),
  aSus({'A#': 10}),
  b({'B': 11});

  final Map<String, int> interval;

  const TuringInstrument(this.interval);
}
