import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class SheetMusic extends StatefulWidget {
  final String svg;
  final Duration duration;

  const SheetMusic({
    Key? key,
    required this.svg,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<SheetMusic> createState() => SheetMusicState();
}

class SheetMusicState extends State<SheetMusic> {
  late String svg;
  late Document svgDocument;

  @override
  Widget build(BuildContext context) {
    final svgKey = ValueKey(svg);
    return AnimatedSwitcher(
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: child.key != svgKey ? const AlwaysStoppedAnimation(1.0) : anim,
        child: child,
      ),
      duration: widget.duration,
      child: SvgPicture.string(
        svg,
        key: svgKey,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    svg = widget.svg;
    svgDocument = parse(widget.svg);
  }

  void setVLinesColor(Color color) {
    for (final path in svgDocument.querySelectorAll('svg > rect')) {
      path.attributes['stroke'] = color.toHex();
      path.attributes['fill'] = color.toHex();
    }
  }

  void setHLinesColor(Color color) {
    for (final path in svgDocument.querySelectorAll('svg > path[fill="none"]')) {
      path.attributes['stroke'] = color.toHex();
    }
  }

  void setKeyColor(Color color) {
    for (final path in svgDocument.querySelectorAll('svg > path:not([fill="none"])')) {
      path.attributes['stroke'] = color.toHex();
      path.attributes['fill'] = color.toHex();
    }
  }

  void setNotesColor(Color color) {
    for (final path in svgDocument.querySelectorAll('.vf-stavenote path')) {
      path.attributes['stroke'] = color.toHex();
      if (path.attributes['fill'] != 'none') {
        path.attributes['fill'] = color.toHex();
      }
    }
  }

  void update() {
    setState(() {
      svg = svgDocument.body!.innerHtml;
    });
  }
}

extension HexColor on Color {
  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}