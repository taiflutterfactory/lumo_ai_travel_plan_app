import 'package:json_annotation/json_annotation.dart';
part 'weather_response.g.dart';

@JsonSerializable()
class WeatherResponse {
  final Main main;
  final List<Weather> weather;
  final String name;
  final Wind wind;

  WeatherResponse({required this.main, required this.weather, required this.name, required this.wind});

  factory WeatherResponse.fromJson(Map<String, dynamic> json) => _$WeatherResponseFromJson(json);
}

@JsonSerializable()
class Main {
  final double temp;
  @JsonKey(name: 'temp_min')
  final double tempMin;
  @JsonKey(name: 'temp_max')
  final double tempMax;
  final int humidity;

  Main({required this.temp, required this.tempMin, required this.tempMax, required this.humidity});

  factory Main.fromJson(Map<String, dynamic> json) => _$MainFromJson(json);
}

@JsonSerializable()
class Weather {
  final String description;
  final String icon;

  Weather({required this.description, required this.icon});

  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);
}

@JsonSerializable()
class Wind {
  final double speed;

  Wind({required this.speed});

  factory Wind.fromJson(Map<String, dynamic> json) => _$WindFromJson(json);
}
