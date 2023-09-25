import 'package:flutter_modular/flutter_modular.dart';
import 'package:tutor_musical/modules/play_score/play_score_page.dart';

class PlayScoreModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child(Modular.initialRoute, child: (context) =>  PlayScorePage());
  }
}
