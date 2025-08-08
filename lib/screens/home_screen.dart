import 'package:flutter/material.dart';
import 'package:lumo_ai_travel_plan_app/screens/sub_screens/attraction_main_screen.dart';
import 'package:lumo_ai_travel_plan_app/screens/sub_screens/food_main_screen.dart';

import '../generated/l10n.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final List<String> _tabKeys = ['attraction', 'bites'];
  String _currentTab = 'attraction';

  // 用一個 Map 把 key 跟對應的 Widget 綁在一起
  final Map<String, Widget> _tabPages = {
    'attraction': const AttractionMainScreen(),
    'bites': const FoodMainScreen(),
  };

  // 根據 key 回傳多語系標籤
  String _labelFor(String key) {
    final loc = S.of(context);
    switch (key) {
      case 'attraction':
        return loc.Attraction; // e.g. 「景點」或「Attractions」
      case 'bites':
        return loc.Bites;      // e.g. 「美食」或「Bites」
      default:
        return key;
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
                children: _tabKeys.map((key) {
                  final isSelected = key == _currentTab;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _currentTab = key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: isSelected
                              ? [
                            const BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 2),
                              blurRadius: 6,
                            )
                          ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            _labelFor(key),        // 這裡使用多語系標籤
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 16,
                              color: isSelected
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            // tab 切換的頁面
            Expanded(
              child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: SizedBox(
                        height: 500,
                        child: _tabPages[_currentTab]!,
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
