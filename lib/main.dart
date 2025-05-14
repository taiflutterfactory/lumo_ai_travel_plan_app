import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumo_ai_travel_plan_app/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'globals.dart' as global;
import 'pages/sub_pages/attraction_main_page.dart';
import 'pages/itinerary_page.dart';
import 'pages/favorite_page.dart';
import 'pages/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("📁 Current Directory: ${Directory.current.path}"); // 印出工作目錄
  try {
    await dotenv.load(fileName: 'assets/.env');
    global.mapApiKey = dotenv.env['GOOGLE_API_KEY']!;
    global.weatherApiKey = dotenv.env['WEATHER_API_KEY']!;
    print("✅ .env 成功載入：${dotenv.env['GOOGLE_API_KEY']}");
    print("✅ .env 成功載入：${dotenv.env['WEATHER_API_KEY']}");
  } catch (e) {
    print("🚨 載入 .env 失敗：$e");
  }
  // 允許從 Google Fonts 伺服器動態取得字體
  GoogleFonts.config.allowRuntimeFetching = true;
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NaviGationBarProvider()),
          ChangeNotifierProvider(create: (_) => SearchBarProvider()),
          ChangeNotifierProvider(create: (_) => LocationProvider()),        ],
        child: const TravelPlanApp()
    )
  );
}

class TravelPlanApp extends StatelessWidget {
  const TravelPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Bottom Navigation",
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.kiwiMaruTextTheme()
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final _pages = [
    const HomePage(),
    const ItineraryPage(),
    const FavoritePage(),
    const SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<NaviGationBarProvider>(context);

    return Scaffold(
      appBar: null,
      body: IndexedStack(
        index: appState.selectedIndex,
        children: _pages,
      )
    );
  }
}