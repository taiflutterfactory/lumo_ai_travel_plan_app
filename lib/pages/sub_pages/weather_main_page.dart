import 'package:flutter/material.dart';

import '../../api/weather_api_services/weather_service.dart';
import '../../globals.dart' as globals;

class WeatherMainPage extends StatefulWidget {
  const WeatherMainPage({super.key});

  @override
  State<WeatherMainPage> createState() => _WeatherMainPage();
}

class _WeatherMainPage extends State<WeatherMainPage> {
  Future<void> _weatherState() async {
    try {
      String apiKey = globals.weatherApiKey;
      final weatherService = WeatherService.create();
      final weatherData = await weatherService.fetchWeather("臺中市", apiKey);

      // 取得天氣描述
      final description = weatherData.records.location[0].weatherElement[0].time[0].parameter.parameterName;

      // 取得溫度
      final temperature = weatherData.records.location[0].weatherElement[2].time[0].parameter.parameterName;

      // 取得降雨機率
      final rainProbability = weatherData.records.location[0].weatherElement[1].time[0].parameter.parameterName;

      print("taitest 🌤 狀況：$description");
      print("taitest 🌡️ 溫度：$temperature°C");
      print("taitest 🌧️ 降雨率：$rainProbability%");
    } catch (e) {
      print("❌ 錯誤：$e");
    }
  }

  @override
  void initState() {
    super.initState();
    _weatherState();
  }

  @override
  Widget build(BuildContext context) {

    return const Center(
      child: Text("今日是個好天氣，適合出去遊玩!"),
    );
  }

}