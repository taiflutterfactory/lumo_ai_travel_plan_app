import 'package:flutter/material.dart';
import 'package:lumo_ai_travel_plan_app/pages/sub_pages/attraction_main_page.dart';
import 'package:lumo_ai_travel_plan_app/pages/sub_pages/food_main_page.dart';
import 'package:lumo_ai_travel_plan_app/pages/sub_pages/weather_main_page.dart';

import '../widget/bottom_navigation_bar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("附近好玩好吃的資訊",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: Color(0xFF8C736F)
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
            tabs: const [
              Tab(text: "景點"),
              Tab(text: "美食"),
              Tab(text: "天氣")
            ]
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(child: AttractionPage(),),
          Center(child: FoodMainPage(),),
          Center(child: WeatherMainPage(),)
        ]
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}