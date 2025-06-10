import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:lumo_ai_travel_plan_app/api/weather_api_services/country_city_api.dart';
import 'package:lumo_ai_travel_plan_app/api/weather_models/city_response.dart';
import 'package:lumo_ai_travel_plan_app/api/weather_models/country_response.dart';

import '../../globals.dart' as globals;

class CountryCityService {
  late final CountryCityApi api;

  CountryCityService._internal(this.api);

  factory CountryCityService.create() {
    final dio = Dio(
      BaseOptions(
        headers: {
          'X-RapidAPI-Key': globals.rapidApi,
          'X-RapidAPI-Host': 'wft-geo-db.p.rapidapi.com',
        },
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // 開發時略過 SSL 憑證驗證（請勿用於上線！）
    if (kDebugMode) {
      dio.httpClientAdapter = IOHttpClientAdapter()
        ..onHttpClientCreate = (HttpClient client) {
          client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
          return client;
      };
    }

    return CountryCityService._internal(CountryCityApi(dio));
  }

  Future<CountryResponse> fetchCountries(int limit) async {
    final result = await api.getCountries(limit);
    return result;
  }

  Future<CityResponse> fetchCities(String countryIds, int limit) async {
    final result = await api.getCitiesByCountry(countryIds, limit);
    return result;
  }
}
