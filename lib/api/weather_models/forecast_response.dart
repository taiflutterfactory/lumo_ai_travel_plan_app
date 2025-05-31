import 'package:json_annotation/json_annotation.dart';
part 'forecast_response.g.dart';

@JsonSerializable()
class ForecastResponse {
  final List<ForecastItem> list;

  ForecastResponse({required this.list});

  factory ForecastResponse.fromJson(Map<String, dynamic> json) => _$ForecastResponseFromJson(json);
}

@JsonSerializable()
class ForecastItem {
  final Main main;
  final List<Weather> weather;
  @JsonKey(name: 'dt_txt')
  final String dateTime;

  ForecastItem({required this.main, required this.weather, required this.dateTime});

  factory ForecastItem.fromJson(Map<String, dynamic> json) => _$ForecastItemFromJson(json);
}

@JsonSerializable()
class Main {
  final double temp;

  Main({required this.temp});

  factory Main.fromJson(Map<String, dynamic> json) => _$MainFromJson(json);
}

@JsonSerializable()
class Weather {
  final String description;
  final String icon;

  Weather({required this.description, required this.icon});

  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);
}
