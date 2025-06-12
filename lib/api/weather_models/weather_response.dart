import 'package:json_annotation/json_annotation.dart';

part 'weather_response.g.dart';

@JsonSerializable()
class WeatherResponse {
  final Records records;
  WeatherResponse({required this.records});
  factory WeatherResponse.fromJson(Map<String, dynamic> json) => _$WeatherResponseFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherResponseToJson(this);
}

@JsonSerializable()
class Records {
  final List<Locations> locations;
  Records({required this.locations});
  factory Records.fromJson(Map<String, dynamic> json) => _$RecordsFromJson(json);
  Map<String, dynamic> toJson() => _$RecordsToJson(this);
}

@JsonSerializable()
class Locations {
  final List<Location> location;
  Locations({required this.location});
  factory Locations.fromJson(Map<String, dynamic> json) => _$LocationsFromJson(json);
  Map<String, dynamic> toJson() => _$LocationsToJson(this);
}

@JsonSerializable()
class Location {
  final String locationName;
  final List<WeatherElement> weatherElement;
  Location({required this.locationName, required this.weatherElement});
  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

@JsonSerializable()
class WeatherElement {
  final String elementName;
  final List<Time> time;
  WeatherElement({required this.elementName, required this.time});
  factory WeatherElement.fromJson(Map<String, dynamic> json) => _$WeatherElementFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherElementToJson(this);
}

@JsonSerializable()
class Time {
  final String startTime;
  final String endTime;
  final ElementValue elementValue;
  Time({required this.startTime, required this.endTime, required this.elementValue});
  factory Time.fromJson(Map<String, dynamic> json) => _$TimeFromJson(json);
  Map<String, dynamic> toJson() => _$TimeToJson(this);
}

@JsonSerializable()
class ElementValue {
  final String value;
  final String measures;
  ElementValue({required this.value, required this.measures});
  factory ElementValue.fromJson(Map<String, dynamic> json) => _$ElementValueFromJson(json);
  Map<String, dynamic> toJson() => _$ElementValueToJson(this);
}
