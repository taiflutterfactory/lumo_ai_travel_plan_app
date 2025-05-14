import 'package:flutter/material.dart';

import '../widget/bottom_navigation_bar_widget.dart';

class ItineraryPage extends StatelessWidget {
  const ItineraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("觀迎來到行程規劃頁"),
      ),
      bottomNavigationBar: CustomBottomNav()
    );
  }
}