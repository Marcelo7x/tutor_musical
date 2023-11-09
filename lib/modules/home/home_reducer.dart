import 'package:asp/asp.dart';
import 'package:file_picker/file_picker.dart';
import 'package:process_run/process_run.dart';
import 'dart:io';

import 'home_atoms.dart';

class HomeReducer extends Reducer {
  HomeReducer() {
    on(() => [fechScores], _fechScore);
    on(() => [addScore], _addScore);
    on(() => [setError], _setError);
  }

  _fechScore() async {
    print('runnig fechScore');
    loading.value = true;

    final Map<String, String> appScoresFileName =
        _loadFilesName('./assets/scores/');
    // scores.value = appScoresFileName.where((e) => e.contains('.txt')).toList();

    final s = [];
    for (var e in appScoresFileName.entries) {
      if (e.value.contains('.txt')) {
        s.add(e);
      }
    }

    scores.value = s;

    loading.value = false;
  }

  Map<String, String> _loadFilesName(String path) {
    var dir = Directory(path);

    List<FileSystemEntity> contents = dir.listSync();
    Map<String, String> filesName = {};
    for (var e in contents) {
      if (e is File) {
        final path = e.path;
        final lastSeparator = path.lastIndexOf("/");
        filesName
            .addAll({path.substring(lastSeparator + 1, path.length): e.path});
      }
    }

    return filesName;
  }

  _addScore() async {
    loading.value = true;

    final filePath = await _filePathPiker();
    print(filePath);

    // await _toSvg(filePath);
    // if (filePath != null) {
    //   state.value = ErrorHomeState();
    // }

    if (filePath != null) {
      await _saveScore(filePath!);
    }

    _fechScore();
    loading.value = false;
  }

  Future<String?> _filePathPiker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['.txt'],
    );

    if (result != null) {
      String filePath = result.files.single.path!;
      return filePath;
    }
    return null;
  }

  _saveScore(String filePath) async {
    final lastSeparator = filePath.lastIndexOf(Platform.pathSeparator);
    final lastPoint = filePath.lastIndexOf('.');
    final fileName =
        filePath.substring(lastSeparator + 1, lastPoint).toString();

    final file = File(filePath);
    final text = await file.readAsString();

    final newFile = File('./assets/scores/$fileName.txt');
    await newFile.writeAsString(text);
  }

  _toSvg(filePath) async {
    var shell = Shell();

    final lastSeparator = filePath.lastIndexOf(Platform.pathSeparator);
    final lastPoint = filePath.lastIndexOf('.');
    final fileName =
        filePath.substring(lastSeparator + 1, lastPoint).toString();

    try {
      final out = await shell.run(
          '.\\external\\Verovio\\bin\\verovio.exe -o .\\assets\\scores\\$fileName.svg $filePath');
    } on ShellException catch (e) {
      print(e);
      setError.value = 'Falha ao carregar Partitura.';
    }
  }

  _setError() {
    if (setError.value != null) error.value = HomeError(setError.value!);
  }
}
