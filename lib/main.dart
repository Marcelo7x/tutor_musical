import 'package:asp/asp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'modules/app_module.dart';
import 'modules/app_widget.dart';

void main() {
  return runApp( ModularApp(module: AppModule(), child: RxRoot(child: AppWidget())));
}
