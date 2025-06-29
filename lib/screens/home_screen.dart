import 'package:flutter/material.dart';
import 'package:lumo_ai_travel_plan_app/screens/sub_screens/attraction_main_screen.dart';
import 'package:lumo_ai_travel_plan_app/screens/sub_screens/food_main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final List<String> tab = ['attraction', 'bites'];
  String optionTab = 'attraction';

  Widget getTabWidget(String tab) {
    // 根據 tab 切換頁面
    switch (tab) {
      case 'attraction':
        return const AttractionMainScreen(); // 景點頁籤
      case 'bites':
        return const FoodMainScreen(); // 餐廳頁籤
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
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: const Text(
                'May light guide your path.',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey
                ),
              ),
            ),
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
                          optionTab = selectedTab;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 8), // 控制按鈕間距
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
                              : [],
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
                    ),
                  );
                }),
              ),
            ),
            // tab 切換的頁面
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
            ),
          ],
        ),
      ),
    );
  }
}
