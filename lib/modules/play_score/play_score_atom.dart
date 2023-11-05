//atoms
import 'package:asp/asp.dart';

final state = Atom<PlayScoreState>(PlayScoreReadyState());
final scoreState = Atom<ScoreState>(ViewScoreState());

//actions
final setError = Atom<String?>(null);

abstract class PlayScoreError {
  final String message;
  const PlayScoreError(this.message);
}

class PlayScoreState {}

class PlayScoreLoadingState extends PlayScoreState {}
class PlayScoreReadyState extends PlayScoreState {}
class PlayScoreErrorState extends PlayScoreState {
  final message;
  PlayScoreErrorState(this.message);
}

class ScoreState {}
class ViewScoreState extends ScoreState {}
class PlayingScoreState extends ScoreState {}
class ResultScoreState extends ScoreState {}
