import 'package:asp/asp.dart';
import 'package:flutter/material.dart';

//atoms
final theme = Atom<ThemeMode>(ThemeMode.light);

//actions
final switchTheme = Atom.action();
