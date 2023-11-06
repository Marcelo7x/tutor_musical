import 'package:flutter_modular/flutter_modular.dart';
import 'package:tutor_musical/modules/play_score/play_score_page.dart';
import 'package:tutor_musical/modules/play_score/play_score_reducer.dart';

class PlayScoreModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(PlayScoreReducer.new);
  }

  @override
  void routes(r) {
    r.child(Modular.initialRoute, child: (context) => PlayScorePage());
  }
}
