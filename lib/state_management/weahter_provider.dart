import 'package:flutter/material.dart';
import '../api/weather_models/weather_response.dart';
import '../api/weather_api_services/weather_service.dart';
import '../globals.dart' as global;

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService;
  WeatherResponse? weatherData;
  bool isLoading = false;

  WeatherProvider(this._weatherService);

  Future<void> fetchWeather(String locationName) async {
    isLoading = true;
    notifyListeners();

    try {
      final data = await _weatherService.getWeather(
        global.weatherApiKey,
        locationName,
        'JSON',
      );
      weatherData = data;
    } catch (e) {
      print('Weather fetch error: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}
