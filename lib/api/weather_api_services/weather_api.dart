// services/weather_api.dart
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../weather_models/weather_response.dart';

part 'weather_api.g.dart';

@RestApi(baseUrl: "https://opendata.cwa.gov.tw/api/v1/rest/datastore/")
abstract class WeatherApi {
  factory WeatherApi(Dio dio, {String baseUrl}) = _WeatherApi;

  @GET("F-C0032-001")
  Future<WeatherResponse> getWeather({
    @Query("Authorization") required String weatherApiKey,
    @Query("locationName") required String location,
  });
}
