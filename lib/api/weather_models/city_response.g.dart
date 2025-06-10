// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

City _$CityFromJson(Map<String, dynamic> json) => City(
      name: json['name'] as String,
    );

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'name': instance.name,
    };

CityResponse _$CityResponseFromJson(Map<String, dynamic> json) => CityResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => City.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CityResponseToJson(CityResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
