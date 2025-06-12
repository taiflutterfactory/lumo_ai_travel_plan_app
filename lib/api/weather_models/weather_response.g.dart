// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherResponse _$WeatherResponseFromJson(Map<String, dynamic> json) =>
    WeatherResponse(
      records: Records.fromJson(json['records'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeatherResponseToJson(WeatherResponse instance) =>
    <String, dynamic>{
      'records': instance.records,
    };

Records _$RecordsFromJson(Map<String, dynamic> json) => Records(
      locations: (json['locations'] as List<dynamic>)
          .map((e) => Locations.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecordsToJson(Records instance) => <String, dynamic>{
      'locations': instance.locations,
    };

Locations _$LocationsFromJson(Map<String, dynamic> json) => Locations(
      location: (json['location'] as List<dynamic>)
          .map((e) => Location.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LocationsToJson(Locations instance) => <String, dynamic>{
      'location': instance.location,
    };

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      locationName: json['locationName'] as String,
      weatherElement: (json['weatherElement'] as List<dynamic>)
          .map((e) => WeatherElement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'locationName': instance.locationName,
      'weatherElement': instance.weatherElement,
    };

WeatherElement _$WeatherElementFromJson(Map<String, dynamic> json) =>
    WeatherElement(
      elementName: json['elementName'] as String,
      time: (json['time'] as List<dynamic>)
          .map((e) => Time.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WeatherElementToJson(WeatherElement instance) =>
    <String, dynamic>{
      'elementName': instance.elementName,
      'time': instance.time,
    };

Time _$TimeFromJson(Map<String, dynamic> json) => Time(
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      elementValue:
          ElementValue.fromJson(json['elementValue'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TimeToJson(Time instance) => <String, dynamic>{
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'elementValue': instance.elementValue,
    };

ElementValue _$ElementValueFromJson(Map<String, dynamic> json) => ElementValue(
      value: json['value'] as String,
      measures: json['measures'] as String,
    );

Map<String, dynamic> _$ElementValueToJson(ElementValue instance) =>
    <String, dynamic>{
      'value': instance.value,
      'measures': instance.measures,
    };
