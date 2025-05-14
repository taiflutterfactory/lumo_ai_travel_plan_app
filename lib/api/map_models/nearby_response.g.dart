// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NearbyResponse _$NearbyResponseFromJson(Map<String, dynamic> json) =>
    NearbyResponse(
      results: (json['results'] as List<dynamic>)
          .map((e) => NearbyResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NearbyResponseToJson(NearbyResponse instance) =>
    <String, dynamic>{
      'results': instance.results,
    };

NearbyResult _$NearbyResultFromJson(Map<String, dynamic> json) => NearbyResult(
      place_id: json['place_id'] as String,
      name: json['name'] as String?,
      geometry: json['geometry'] == null
          ? null
          : Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => Photo.fromJson(e as Map<String, dynamic>))
          .toList(),
      vicinity: json['vicinity'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$NearbyResultToJson(NearbyResult instance) =>
    <String, dynamic>{
      'place_id': instance.place_id,
      'name': instance.name,
      'geometry': instance.geometry,
      'photos': instance.photos,
      'vicinity': instance.vicinity,
      'rating': instance.rating,
    };

Geometry _$GeometryFromJson(Map<String, dynamic> json) => Geometry(
      location: json['location'] == null
          ? null
          : Location.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GeometryToJson(Geometry instance) => <String, dynamic>{
      'location': instance.location,
    };

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };

Photo _$PhotoFromJson(Map<String, dynamic> json) => Photo(
      photoReference: json['photo_reference'] as String?,
    );

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'photo_reference': instance.photoReference,
    };
