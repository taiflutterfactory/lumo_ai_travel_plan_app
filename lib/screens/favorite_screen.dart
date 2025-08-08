import 'package:flutter/material.dart';
import 'package:lumo_ai_travel_plan_app/screens/sub_screens/favorite_attraction_main_screen.dart';
import 'package:lumo_ai_travel_plan_app/screens/sub_screens/favorite_food_main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../generated/l10n.dart';
import '../widget/bottom_navigation_bar_layout.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final List<String> _tabKeys = ['attraction', 'bites'];
  String _currentTab = 'attraction';

  // 用一個 Map 把 key 跟對應的 Widget 綁在一起
  final Map<String, Widget> _tabPages = {
    'attraction': const FavoriteAttractionMainScreen(),
    'bites': const FavoriteFoodMainScreen(),
  };

  // 根據 key 回傳對應的 Widget
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
            // 頁籤導航欄
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
                            _labelFor(key),
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
            // 根據頁籤選擇顯示不同內容
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
            )
          ],
        )
      ),
    );
  }
}
