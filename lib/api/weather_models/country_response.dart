import 'package:json_annotation/json_annotation.dart';

part 'country_response.g.dart';

@JsonSerializable()
class Country {
  final String code;    // ISO2 Code
  final String name;    // 國家名稱

  Country({required this.code, required this.name});

  factory Country.fromJson(Map<String, dynamic> json) => _$CountryFromJson(json);
  Map<String, dynamic> toJson() => _$CountryToJson(this);
}

@JsonSerializable()
class CountryResponse {
  final List<Country> data;

  CountryResponse({required this.data});

  factory CountryResponse.fromJson(Map<String, dynamic> json) => _$CountryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CountryResponseToJson(this);
}
