import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<NaviGationBarProvider>(context);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF8C736F),
      currentIndex: appState.selectedIndex,
      onTap: (index) {
        appState.setSelectedIndex(index);
      },
      selectedItemColor: const Color(0xFF97A5C0),
      unselectedItemColor: Colors.white,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "首頁"),
        BottomNavigationBarItem(icon: Icon(Icons.schedule), label: "行程"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "收藏"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "設定")
      ],
    );
  }
}