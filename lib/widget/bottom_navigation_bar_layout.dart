import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../generated/l10n.dart';

class BottomNavigationBarLayout extends StatelessWidget {
  final Widget child;
  const BottomNavigationBarLayout({super.key, required this.child});

  static const tabs = [
    '/home',
    '/itinerary',
    '/favorite',
    '/settings',
  ];

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    int getCurrentIndex() {
      final index = tabs.indexWhere((path) => location.startsWith(path));
      return index == -1 ? 0 : index;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: getCurrentIndex(),
        onTap: (index) {
          context.go(tabs[index]);
        },
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: S.of(context).Home,),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: S.of(context).Itinerary),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: S.of(context).Favorite),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: S.of(context).Settings),
        ],
        backgroundColor: const Color(0xFF8C736F),
        selectedItemColor: const Color(0xFF97A5C0),
        unselectedItemColor: Colors.white,
      ),
    );
  }
}
