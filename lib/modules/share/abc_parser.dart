interface class ABCElement {}

class ABCMetro extends ABCElement {
  final String metro;

  ABCMetro({required this.metro});
}

class ABCNote extends ABCElement {
  final String note;
  final String? accident;
  final List<ABCMultDivLength>? duration;

  ABCNote({required this.note, this.duration, this.accident});
}

class ABCPause extends ABCElement {
  final List<ABCMultDivLength>? duration;

  ABCPause({this.duration});
}

class ABCTone extends ABCElement {
  final String tone;

  ABCTone({required this.tone});
}

class ABCLength extends ABCElement {
  final double length;

  ABCLength({required this.length});
}

class ABCMultDivLength extends ABCElement {
  final bool isMult;

  ABCMultDivLength({required this.isMult});
}

class ABCCompasseSeparator extends ABCElement {
  ABCCompasseSeparator();
}

class ABCMusic {
  final int numberOfComposition;
  final String title;
  final String composer;
  final String metro;
  final List<ABCElement> elements;

  ABCMusic(
      {required this.numberOfComposition,
      required this.title,
      required this.composer,
      required this.metro,
      required this.elements});
}

ABCMusic parse(String abcText) {
  final lines = abcText.split('\n');
  final notes = <ABCElement>[];

  int numberOfComposition = 1;
  String title = '';
  String composer = '';
  String metro = '';
  String tone = '';
  List<ABCElement> elements = [];

  for (final line in lines) {
    if (line.startsWith('X:')) {
      numberOfComposition = int.parse(line.substring(2));
    } else if (line.startsWith('T:')) {
      title = line.substring(2).trim();
    } else if (line.startsWith('C:')) {
      composer = line.substring(2).trim();
    } else if (line.startsWith('M:')) {
      metro = line.substring(2, 5);
    } else if (line.startsWith('K:')) {
      tone = line.substring(2, 2);
      elements.add(ABCTone(tone: tone));
    } else {
      elements.addAll(_parseElements(line));
    }
  }

  return ABCMusic(
    numberOfComposition: numberOfComposition,
    title: title,
    composer: composer,
    metro: metro,
    elements: elements,
  );
}

final lengthRegExp = RegExp(r'\[L:(\d+)/(\d+)\]');
final noteRegExp = RegExp(r'^[A-Ga-g](/2)*');
final noteWithAccidentRegExp = RegExp(r'^([=^_]{1,2}[A-Ga-g][/2]*)*$');
final pauseRegExp = RegExp(r'z(\/2)*');

List<ABCMultDivLength> _createMultDiv(String el) {
  final multDiv = <ABCMultDivLength>[];
  for (int i = 0; i < el.length; i++) {
    if (el[i] == '2' || el[i] == '/') {
      multDiv.add(ABCMultDivLength(isMult: el[i] == '2'));
    }
  }
  return multDiv;
}

List<ABCElement> _parseElements(String line) {
  final elements = <ABCElement>[];
  final sElements = line.split(' ');

  for (String el in sElements) {
    if (el.isEmpty) continue;
    if (lengthRegExp.hasMatch(el)) {
      final match = lengthRegExp.firstMatch(el);
      final length = int.parse(match!.group(1)!) / int.parse(match.group(2)!);
      elements.add(ABCLength(length: length));
    } else if (noteRegExp.hasMatch(el)) {
      final note = el.split(RegExp(r'[/2]+'))[0];
      elements.add(ABCNote(note: note, duration: _createMultDiv(el)));
    } else if (noteWithAccidentRegExp.hasMatch(el)) {
      final note = el[el.indexOf(RegExp(r'[A-Ga-g]'))];
      String? accident;
      if (el.startsWith('^')) {
        accident = '^';
      } else if (el.startsWith('_')) {
        accident = '_';
      } else if (el.startsWith('=')) {
        accident = '=';
      }
      elements.add(ABCNote(
          note: note, duration: _createMultDiv(el), accident: accident));
    } else if (pauseRegExp.hasMatch(el)) {
      elements.add(ABCPause(duration: _createMultDiv(el)));
    } else if (el == '|') {
      elements.add(ABCCompasseSeparator());
    }
  }
  return elements;
}
