import 'package:flutter/material.dart';
import 'package:lumo_ai_travel_plan_app/screens/sub_screens/favorite_attraction_main_screen.dart';
import 'package:lumo_ai_travel_plan_app/screens/sub_screens/favorite_food_main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/bottom_navigation_bar_layout.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final List<String> tab = ['attraction', 'bites'];
  String optionTab = 'attraction';

  // 根據頁籤切換對應的 Widget
  Widget getTabWidget(String tab) {
    switch (tab) {
      case 'attraction':
        return const FavoriteAttractionMainScreen(); // 收藏景點頁籤
      case 'bites':
        return const FavoriteFoodMainScreen(); // 收藏餐廳頁籤
      default:
        return const Center(child: Text('Unknown tab'),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 頁籤導航欄
            Container(
              height: 90,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: List.generate(tab.length, (index) {
                  final selectedTab = tab[index];
                  final isSelected = selectedTab == optionTab;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          optionTab = selectedTab; // 點擊頁籤時切換
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: isSelected
                            ? [
                              const BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 2),
                                blurRadius: 6,
                                spreadRadius: 1,
                              )
                          ]
                            :[],
                        ),
                        child: Center(
                          child: Text(
                            selectedTab[0].toUpperCase() + selectedTab.substring(1),
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 16,
                              color: isSelected ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    )
                  );
                }),
              ),
            ),

            // 根據頁籤選擇顯示不同內容
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: SizedBox(
                      height: 500,
                      child: getTabWidget(optionTab),
                    ),
                  );
                }
              )
            )
          ],
        )
      ),
    );
  }
}
