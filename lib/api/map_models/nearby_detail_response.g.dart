// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NearbyDetailResponse _$NearbyDetailResponseFromJson(
        Map<String, dynamic> json) =>
    NearbyDetailResponse(
      result:
          NearbyDetailResult.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NearbyDetailResponseToJson(
        NearbyDetailResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
    };

NearbyDetailResult _$NearbyDetailResultFromJson(Map<String, dynamic> json) =>
    NearbyDetailResult(
      name: json['name'] as String,
      formatted_address: json['formatted_address'] as String?,
      formatted_phone_number: json['formatted_phone_number'] as String?,
      website: json['website'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => Photo.fromJson(e as Map<String, dynamic>))
          .toList(),
      opening_hours: json['opening_hours'] == null
          ? null
          : OpeningHours.fromJson(
              json['opening_hours'] as Map<String, dynamic>),
      editorial_summary: json['editorial_summary'] == null
          ? null
          : EditorialSummary.fromJson(
              json['editorial_summary'] as Map<String, dynamic>),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList(),
      geometry: json['geometry'] == null
          ? null
          : Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NearbyDetailResultToJson(NearbyDetailResult instance) =>
    <String, dynamic>{
      'name': instance.name,
      'formatted_address': instance.formatted_address,
      'formatted_phone_number': instance.formatted_phone_number,
      'website': instance.website,
      'rating': instance.rating,
      'photos': instance.photos,
      'opening_hours': instance.opening_hours,
      'editorial_summary': instance.editorial_summary,
      'reviews': instance.reviews,
      'geometry': instance.geometry,
    };

EditorialSummary _$EditorialSummaryFromJson(Map<String, dynamic> json) =>
    EditorialSummary(
      overview: json['overview'] as String,
    );

Map<String, dynamic> _$EditorialSummaryToJson(EditorialSummary instance) =>
    <String, dynamic>{
      'overview': instance.overview,
    };

Photo _$PhotoFromJson(Map<String, dynamic> json) => Photo(
      photo_reference: json['photo_reference'] as String,
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
    );

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'photo_reference': instance.photo_reference,
      'width': instance.width,
      'height': instance.height,
    };

OpeningHours _$OpeningHoursFromJson(Map<String, dynamic> json) => OpeningHours(
      open_now: json['open_now'] as bool,
      weekday_text: (json['weekday_text'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$OpeningHoursToJson(OpeningHours instance) =>
    <String, dynamic>{
      'open_now': instance.open_now,
      'weekday_text': instance.weekday_text,
    };

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      author_name: json['author_name'] as String?,
      profile_photo_url: json['profile_photo_url'] as String?,
      text: json['text'] as String?,
      rating: (json['rating'] as num?)?.toInt(),
      relative_time_description: json['relative_time_description'] as String?,
    );

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'author_name': instance.author_name,
      'profile_photo_url': instance.profile_photo_url,
      'text': instance.text,
      'rating': instance.rating,
      'relative_time_description': instance.relative_time_description,
    };

Geometry _$GeometryFromJson(Map<String, dynamic> json) => Geometry(
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GeometryToJson(Geometry instance) => <String, dynamic>{
      'location': instance.location,
    };

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };
