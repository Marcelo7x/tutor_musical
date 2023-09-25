import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  NavBar(
      {super.key,
      required this.destinations,
      this.selectedIndex = 0,
      this.onDestinationSelected});
  final List<NavigationDestination> destinations;
  int selectedIndex;
  final void Function(int)? onDestinationSelected;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.sizeOf(context).height;
    // final width = MediaQuery.sizeOf(context).width;

    return NavigationBar(
      // height: height * .1,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: widget.onDestinationSelected,
      selectedIndex: widget.selectedIndex,
      destinations: widget.destinations,
    );
  }
}
