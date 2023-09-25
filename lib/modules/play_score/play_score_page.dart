import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tutor_musical/modules/share/score_builder.dart';

import 'widget/pauta.dart';

class PlayScorePage extends StatefulWidget {
  const PlayScorePage({super.key});

  @override
  State<PlayScorePage> createState() => _PlayScorePageState();
}

class _PlayScorePageState extends State<PlayScorePage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    final availableHeight = MediaQuery.sizeOf(context).height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    const spaceSize = 15.0;

    return Scaffold(
      body: Container(
        // height: availableHeight,
        width: width,
        padding: const EdgeInsets.all(20),
        child: const Column(
          children: [
            // const Pauta(
            //   spaceSize: spaceSize,
            // ),
            // SizedBox(
            //   height: 12 * spaceSize,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Container(
            //         height: 8 * spaceSize,
            //         alignment: Alignment.bottomCenter,
            //         child: Container(
            //           height: spaceSize * 4,
            //           decoration: const BoxDecoration(
            //               border: Border(
            //             left: BorderSide(color: Colors.black, width: 1.2),
            //           )),
            //         ),
            //       ),
            //       Container(
            //         height: 7 * spaceSize,
            //         alignment: Alignment.bottomCenter,
            //         child: Image.file(
            //           File('assets/fig/g51.png'),
            //           height: 3 * spaceSize,
            //           width: 50,
            //           color: Colors.black,
            //         ),
            //       ),
            //       Container(
            //         height: 8 * spaceSize,
            //         alignment: Alignment.bottomCenter,
            //         // padding: const EdgeInsets.only(bottom: 10),
            //         child: Image.file(
            //           File('assets/fig/path54.png'),
            //           height: spaceSize,
            //           color: Colors.black,
            //         ),
            //       ),
            //       Container(
            //         height: 6.5 * spaceSize,
            //         alignment: Alignment.bottomCenter,
            //         // padding: const EdgeInsets.only(bottom: 10),
            //         child: Image.file(
            //           File('assets/fig/path54.png'),
            //           height: spaceSize,
            //           color: Colors.black,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '\uEB90\uE030\uE01A',
                  style: TextStyle(
                    fontFamily: 'Bravura',
                    fontSize: 100,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 120),
                  child: Text(
                    '\uE262',
                    style: TextStyle(
                      fontFamily: 'Bravura',
                      fontSize: 100,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              '\ue020\ue01a\ue050\ue014-\ue014-\ue014\ueb9b\ue1d5\ue014=\ue014=\ue034',
              style: TextStyle(
                fontFamily: 'Bravura',
                fontSize: 200,
                color: Colors.white,
                fontFeatures: [
                  FontFeature.enable('liga'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
