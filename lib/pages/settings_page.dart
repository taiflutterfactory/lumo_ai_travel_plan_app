import 'package:flutter/material.dart';
import 'package:lumo_ai_travel_plan_app/widget/bottom_navigation_bar_widget.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("觀迎來到設定頁"),
      ),
      bottomNavigationBar: CustomBottomNav()
    );
  }
}