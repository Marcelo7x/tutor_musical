import 'package:flutter_modular/flutter_modular.dart';
import 'package:tutor_musical/modules/play_score/play_score_module.dart';
import 'app_reducer.dart';
import 'home/home_module.dart';
import 'home/home_reducer.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    // i.addSingleton(HomeReducer.new);
    i.addSingleton(AppReduce.new);
  }

  @override
  void routes(r) {
    r.module('/', module: HomeModule());
  }
}
