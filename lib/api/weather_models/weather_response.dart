// models/weather_response.dart
import 'package:json_annotation/json_annotation.dart';

part 'weather_response.g.dart';

@JsonSerializable()
class WeatherResponse {
  final Records records;

  WeatherResponse({required this.records});

  factory WeatherResponse.fromJson(Map<String, dynamic> json) =>
      _$WeatherResponseFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherResponseToJson(this);
}

@JsonSerializable()
class Records {
  final List<Location> location;

  Records({required this.location});

  factory Records.fromJson(Map<String, dynamic> json) =>
      _$RecordsFromJson(json);
  Map<String, dynamic> toJson() => _$RecordsToJson(this);
}

@JsonSerializable()
class Location {
  final String locationName;
  final List<WeatherElement> weatherElement;

  Location({required this.locationName, required this.weatherElement});

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

@JsonSerializable()
class WeatherElement {
  final String elementName;
  final List<Time> time;

  WeatherElement({required this.elementName, required this.time});

  factory WeatherElement.fromJson(Map<String, dynamic> json) =>
      _$WeatherElementFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherElementToJson(this);
}

@JsonSerializable()
class Time {
  final String startTime;
  final String endTime;
  final Parameter parameter;

  Time({required this.startTime, required this.endTime, required this.parameter});

  factory Time.fromJson(Map<String, dynamic> json) => _$TimeFromJson(json);
  Map<String, dynamic> toJson() => _$TimeToJson(this);
}

@JsonSerializable()
class Parameter {
  final String parameterName;
  final String? parameterValue;

  Parameter({required this.parameterName, this.parameterValue});

  factory Parameter.fromJson(Map<String, dynamic> json) =>
      _$ParameterFromJson(json);
  Map<String, dynamic> toJson() => _$ParameterToJson(this);
}