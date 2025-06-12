
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../weather_models/weather_response.dart';

part 'weather_api.g.dart';

@RestApi(baseUrl: "https://opendata.cwa.gov.tw/api/v1/rest/datastore/")
abstract class WeatherApi {
  factory WeatherApi(Dio dio, {String baseUrl}) = _WeatherApi;

  // 三天天氣預報(鄉鎮)
  @GET("F-D0047-089")
  Future<WeatherResponse> getWeather(
    @Query("Authorization") String apiKey,
    @Query("locationName") String locationName,
    @Query("format") String format
    );
}
