import 'package:asp/asp.dart';
import 'package:flutter/material.dart';
import 'package:tutor_musical/modules/app_atom.dart';

class AppReduce extends Reducer {
  AppReduce() {
    on(() => [switchTheme], _swichtTheme);
  }

  _swichtTheme() {
    theme.value =
        theme.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}
