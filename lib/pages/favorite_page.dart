import 'package:flutter/material.dart';

import '../widget/bottom_navigation_bar_widget.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("觀迎來到收藏頁"),
      ),
      bottomNavigationBar: CustomBottomNav()
    );
  }
}