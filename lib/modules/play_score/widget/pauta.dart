import 'package:flutter/material.dart';

class Pauta extends StatelessWidget {
  const Pauta({super.key, this.spaceSize = 10});
  final double spaceSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: spaceSize * 12,
      padding: EdgeInsets.only(top: spaceSize * 3),
      child: Column(
        children: [
          Container(
            height: spaceSize,
            decoration: const BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Colors.black, width: 1),
            )),
          ),
          Container(
            height: spaceSize,
            decoration: const BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Colors.black, width: 1),
            )),
          ),
          Container(
            height: spaceSize,
            decoration: const BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Colors.black, width: 1),
            )),
          ),
          Container(
            height: spaceSize,
            decoration: const BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Colors.black, width: 1),
            )),
          ),
          Container(
            height: spaceSize,
            decoration: const BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Colors.black, width: 1),
            )),
          ),
        ],
      ),
    );
  }
}
