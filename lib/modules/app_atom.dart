import 'package:asp/asp.dart';
import 'package:flutter/material.dart';

//atoms
final theme = Atom<ThemeMode>(ThemeMode.dark);

//actions
final switchTheme = Atom.action();
