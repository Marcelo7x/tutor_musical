//atoms
import 'package:asp/asp.dart';

final loading = Atom<bool>(false);
final error = Atom<PlayScoreError>(const PlayScoreError(''));


//actions
final setError = Atom<String?>(null);

class PlayScoreError {
  final String message;
  const PlayScoreError(this.message);
}