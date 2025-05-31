import 'package:flutter/material.dart';

import '../widget/bottom_navigation_bar_layout.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(child: Text('Welcome to Favorite'),)
    );
  }
}
