// services/weather_api.dart
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../weather_models/forecast_response.dart';
import '../weather_models/weather_response.dart';

part 'weather_api.g.dart';

@RestApi(baseUrl: "https://api.openweathermap.org/data/2.5/")
abstract class WeatherApi {
  factory WeatherApi(Dio dio, {String baseUrl}) = _WeatherApi;

  @GET("weather")
  Future<WeatherResponse> getCurrentWeather(
      @Query("q") String city,
      @Query("appid") String apiKey,
      @Query("units") String units,
      @Query("lang") String lang,
  );

  @GET("forecast")
  Future<ForecastResponse> getForecast(
      @Query("q") String city,
      @Query("appid") String apiKey,
      @Query("units") String units,
      @Query("lang") String lang,
  );
}
