import 'package:flutter/material.dart';
import 'package:lumo_ai_travel_plan_app/screens/sub_screens/attraction_main_screen.dart';
import 'package:lumo_ai_travel_plan_app/screens/sub_screens/food_main_screen.dart';
import 'package:lumo_ai_travel_plan_app/screens/sub_screens/weather_main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final List<String> tab = ['attraction', 'bites', 'weather'];
  String optionTab = 'attraction';

  Widget getTabWidget(String tab) {
    // 根據 tab 切換頁面
    switch (tab) {
      case 'attraction':
        return const AttractionMainScreen();
      case 'bites':
        return const FoodMainScreen();
      case 'weather':
        return const WeatherMainScreen();
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
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: const Text(
                'May light walk with you on every path you tread.',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Container(
              height: 90,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: tab.length,
                separatorBuilder: (_,__) => const SizedBox(width: 12,),
                itemBuilder: (context, index) {
                  final selectedTab = tab[index];
                  final isSelected = selectedTab == optionTab;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        optionTab = selectedTab;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isSelected
                            ?[
                          const BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 2),
                              blurRadius: 6,
                              spreadRadius: 1
                          )
                        ]
                            :[],
                      ),
                      child: Text(
                        selectedTab[0].toUpperCase() + selectedTab.substring(1),
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 15,
                          color: isSelected ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
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
