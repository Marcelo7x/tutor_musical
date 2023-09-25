import 'package:asp/asp.dart';

//atoms
final loading = Atom<bool>(false);
final error = Atom<HomeError>(const HomeError(''));
final scores = Atom<List>([]);

//actions
final fechScores = Atom.action();
final addScore = Atom.action();
final setError = Atom<String?>(null);

class HomeError {
  final String message;
  const HomeError(this.message);
}
