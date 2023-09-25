import 'package:flutter_modular/flutter_modular.dart';
import 'package:tutor_musical/modules/home/pages/scoresPage.dart';

import '../play_score/play_score_module.dart';
import 'home_page.dart';
import 'home_reducer.dart';
import 'pages/settingsPage.dart';

class HomeModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(HomeReducer.new);
  }

  @override
  void routes(r) {
    r.child(
      Modular.initialRoute,
      transition: TransitionType.fadeIn,
      child: (context) => const HomePage(),
      children: [
        ChildRoute("/scores",
            child: (context) => const ScoresPage(),),
        ChildRoute("/settings",
            child: (context) => const SettingsPage(),),
      ],
    );
    r.module('/play', module: PlayScoreModule());
  }
}
