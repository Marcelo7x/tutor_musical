interface class ABCElement {}

class ABCMetro extends ABCElement {
  final String metro;

  ABCMetro({required this.metro});
}

class ABCNote extends ABCElement {
  final String note;
  final List<ABCMultDivLength>? duration;

  ABCNote({required this.note, this.duration});
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
      metro = line.substring(2, 4);
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

List<ABCElement> _parseElements(String line) {
  final elements = <ABCElement>[];
  final sElements = line.split(' ');

  for (String el in sElements) {
    if (RegExp(r'\[L:\d+/\d+\]').hasMatch(el)) {
      final match = RegExp(r'\[L:(\d+)/(\d+)\]').firstMatch(el);
      final length = int.parse(match!.group(1)!) / int.parse(match.group(2)!);
      elements.add(ABCLength(length: length));
    } else if (RegExp(r'[A-Ga-g](\/2)*').hasMatch(el)) {
      final note = el.split(RegExp(r'[/2]+'))[0];

      final multDiv = <ABCMultDivLength>[];
      for (int i = 0; i < el.length - 1; i++) {
        multDiv.add(ABCMultDivLength(isMult: el[i + 1] == '2'));
      }
      elements.add(ABCNote(note: note, duration: multDiv));
    } else if (RegExp(r'z(\/2)*').hasMatch(el)) {
      final multDiv = <ABCMultDivLength>[];

      for (int i = 0; i < el.length - 1; i++) {
        multDiv.add(ABCMultDivLength(isMult: el[i + 1] == '2'));
      }

      elements.add(ABCPause(duration: multDiv));
    } else if (el == '|') {
      elements.add(ABCCompasseSeparator());
    }
  }
  return elements;
}
