import 'dart:convert';
import 'dart:io';
import './smufl_specification/glyphnames.dart';

class ScoreBuilder {
  final File score;
  ScoreBuilder({required this.score});
}

class ScoreElements {
  ScoreElements() {
    
  }
}

class _ScoreElementsName {
  static List<String> names = glyphnames.keys.toList();
}
