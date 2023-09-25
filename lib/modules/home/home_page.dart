import 'package:asp/asp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home_atoms.dart';
import 'widgets/navBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedPageIndex = 0;
  final pagesRoutes = [
    '/scores',
    '/settings',
  ];

  @override
  void initState() {
    super.initState();
    Modular.to.navigate(pagesRoutes[0]);
    fechScores();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    final availableHeight = MediaQuery.sizeOf(context).height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    void _showPopup(HomeError? homeErro) {
      if (homeErro == null) return;
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                content: Text(
                  homeErro?.message ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      setError.value = null;
                      Modular.to.pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ));
    }

    context.select(() => [scores, loading, error]);
    context.callback(() => error.value, _showPopup);

    return Scaffold(
      body: const RouterOutlet(),
      bottomNavigationBar: NavBar(
        selectedIndex: selectedPageIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedPageIndex = index;
            Modular.to.navigate(pagesRoutes[selectedPageIndex]);
          });
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.music_note), label: "Patirturas"),
          NavigationDestination(
              icon: Icon(Icons.settings), label: "Configurações"),
        ],
      ),
    );
  }
}
