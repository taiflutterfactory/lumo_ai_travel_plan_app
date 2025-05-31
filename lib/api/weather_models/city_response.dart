import 'package:json_annotation/json_annotation.dart';

part 'city_response.g.dart';

@JsonSerializable()
class City {
  final String name;    // 城市名稱

  City({required this.name});

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
  Map<String, dynamic> toJson() => _$CityToJson(this);
}

@JsonSerializable()
class CityResponse {
  final List<City> data;

  CityResponse({required this.data});

  factory CityResponse.fromJson(Map<String, dynamic> json) => _$CityResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CityResponseToJson(this);
}
