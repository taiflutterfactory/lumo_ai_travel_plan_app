import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import '../weather_models/weather_response.dart';
import 'weather_api.dart';

class WeatherService {
  late final WeatherApi api;

  WeatherService._internal(this.api);

  factory WeatherService.create() {
    final dio = Dio();

    // ⭐️ 開發時略過 SSL 憑證驗證（請勿用於上線！）
    if (kDebugMode) {
      dio.httpClientAdapter = IOHttpClientAdapter()
        ..onHttpClientCreate = (HttpClient client) {
          client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
          return client;
        };
    }

    return WeatherService._internal(WeatherApi(dio));
  }

  Future<WeatherResponse> fetchWeather(String city, String weatherApiKey) async {
    print("taitest, $city, $weatherApiKey");
    final result = await api.getWeather(location: city, weatherApiKey: weatherApiKey);
    return result;
  }
}