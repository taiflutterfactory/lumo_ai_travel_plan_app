import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../generated/l10n.dart';

class AppLayoutScreen extends StatelessWidget {
  final Widget child;

  const AppLayoutScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange,
                    ),
                    child: const Icon(Icons.person, size: 70),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tai',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '@xyz_tai',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6C6C6C),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.menu, size: 28,),
                    onSelected: (String value) {
                      // 根據選到的選項切換頁面
                      switch (value) {
                        case 'home':
                          context.go('/home');
                          break;
                        case 'itinerary':
                          context.go('/itinerary');
                          break;
                        case 'favorite':
                          context.go('/favorite');
                          break;
                        case 'settings':
                          context.go('/settings');
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        value: 'home',
                        child: Row(
                          children: [
                            Icon(Icons.home),
                            SizedBox(width: 2,),
                            Text(S.of(context).Home),
                          ],
                        )
                      ),
                      PopupMenuItem<String>(
                        value: 'itinerary',
                        child: Row(
                          children: [
                            Icon(Icons.map),
                            SizedBox(width: 2,),
                            Text(S.of(context).Itinerary),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'favorite',
                        child: Row(
                          children: [
                            Icon(Icons.favorite),
                            SizedBox(width: 2,),
                            Text(S.of(context).Favorite),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'settings',
                        child: Row(
                          children: [
                            Icon(Icons.settings),
                            SizedBox(width: 2,),
                            Text(S.of(context).Settings),
                          ],
                        ),
                      ),
                    ]
                  ),
                ],
              ),
            ),
            Expanded(child: child), // 頁面內容
          ],
        ),
      )
    );
  }
}
