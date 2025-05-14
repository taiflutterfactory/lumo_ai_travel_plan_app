import 'package:json_annotation/json_annotation.dart';

part 'nearby_detail_response.g.dart';

@JsonSerializable()
class NearbyDetailResponse {
  final NearbyDetailResult result;

  NearbyDetailResponse({required this.result});

  factory NearbyDetailResponse.fromJson(Map<String, dynamic> json) => _$NearbyDetailResponseFromJson(json);
  Map<String, dynamic> toJson() => _$NearbyDetailResponseToJson(this);
}

@JsonSerializable()
class NearbyDetailResult {
  final String name;
  final String? formatted_address;
  final String? formatted_phone_number;
  final String? website;
  final double? rating;
  final List<Photo>? photos;
  final OpeningHours? opening_hours;
  final EditorialSummary? editorial_summary;
  final List<Review>? reviews;
  final Geometry? geometry;

  NearbyDetailResult({
    required this.name,
    this.formatted_address,
    this.formatted_phone_number,
    this.website,
    this.rating,
    this.photos,
    this.opening_hours,
    this.editorial_summary,
    this.reviews,
    this.geometry,
  });

  factory NearbyDetailResult.fromJson(Map<String, dynamic> json) => _$NearbyDetailResultFromJson(json);
  Map<String, dynamic> toJson() => _$NearbyDetailResultToJson(this);
}

@JsonSerializable()
class EditorialSummary {
  final String overview;

  EditorialSummary({required this.overview});

  factory EditorialSummary.fromJson(Map<String, dynamic> json) => _$EditorialSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$EditorialSummaryToJson(this);
}

@JsonSerializable()
class Photo {
  final String photo_reference;
  final int width;
  final int height;

  Photo({required this.photo_reference, required this.width, required this.height});

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}

@JsonSerializable()
class OpeningHours {
  final bool open_now;
  final List<String> weekday_text;

  OpeningHours({required this.open_now, required this.weekday_text});

  factory OpeningHours.fromJson(Map<String, dynamic> json) => _$OpeningHoursFromJson(json);
  Map<String, dynamic> toJson() => _$OpeningHoursToJson(this);
}

@JsonSerializable()
class Review {
  final String? author_name;
  final String? profile_photo_url;
  final String? text;
  final int? rating;
  final String? relative_time_description;

  Review({this.author_name, this.profile_photo_url, this.text, this.rating, this.relative_time_description});

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}

@JsonSerializable()
class Geometry {
  final Location location;

  Geometry({required this.location});

  factory Geometry.fromJson(Map<String, dynamic> json) => _$GeometryFromJson(json);
  Map<String, dynamic> toJson() => _$GeometryToJson(this);
}

@JsonSerializable()
class Location {
  final double lat;
  final double lng;

  Location({required this.lat, required this.lng});

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
