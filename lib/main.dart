import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumo_ai_travel_plan_app/providers/itinerary_provider.dart';
import 'package:lumo_ai_travel_plan_app/screens/app_layout_screen.dart';
import 'package:lumo_ai_travel_plan_app/screens/home_screen.dart';
import 'package:provider/provider.dart';

import 'globals.dart' as global;
import 'screens/favorite_screen.dart';
import 'screens/itinerary_screen.dart';
import 'screens/settings_screen.dart';
import 'providers/location_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("📁 Current Directory: ${Directory.current.path}"); // 印出工作目錄
  try {
    await dotenv.load(fileName: 'assets/.env');
    global.mapApiKey = dotenv.env['GOOGLE_API_KEY']!;
    global.chatGptApiKey = dotenv.env['CHAT_GPT_API_KEY']!;
    print("✅ .env 成功載入：${dotenv.env['GOOGLE_API_KEY']}");
    print("✅ .env 成功載入：${dotenv.env['CHAT_GPT_API_KEY']}");
  } catch (e) {
    print("🚨 載入 .env 失敗：$e");
  }
  // 允許從 Google Fonts 伺服器動態取得字體
  GoogleFonts.config.allowRuntimeFetching = true;
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocationProvider()),
          ChangeNotifierProvider(create: (_) => ItineraryProvider()),
        ],
        child: TravelPlanApp()
    )
  );
}

class TravelPlanApp extends StatelessWidget {
  TravelPlanApp({super.key});

  final _router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => const AppLayoutScreen(child: HomeScreen()),
      ),
      GoRoute(
        path: '/itinerary',
        builder: (context, state) => const AppLayoutScreen(child: ItineraryScreen()),
      ),
      GoRoute(
        path: '/favorite',
        builder: (context, state) => const AppLayoutScreen(child: FavoriteScreen()),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const AppLayoutScreen(child: SettingsPage()),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      title: "Flutter Bottom Navigation",
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.kiwiMaruTextTheme()
      ),
    );
  }
}
