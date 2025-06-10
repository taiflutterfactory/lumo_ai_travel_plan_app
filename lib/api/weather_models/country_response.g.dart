// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Country _$CountryFromJson(Map<String, dynamic> json) => Country(
      code: json['code'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
    };

CountryResponse _$CountryResponseFromJson(Map<String, dynamic> json) =>
    CountryResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => Country.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CountryResponseToJson(CountryResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
