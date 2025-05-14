import 'package:json_annotation/json_annotation.dart';

part 'nearby_response.g.dart';

@JsonSerializable()
class NearbyResponse {
  final List<NearbyResult> results;

  NearbyResponse({required this.results});

  factory NearbyResponse.fromJson(Map<String, dynamic> json) =>
      _$NearbyResponseFromJson(json);
  Map<String, dynamic> toJson() => _$NearbyResponseToJson(this);
}

@JsonSerializable()
class NearbyResult {
  final String place_id;
  final String? name;
  final Geometry? geometry;
  final List<Photo>? photos;
  final String? vicinity;
  final double? rating;

  NearbyResult({
    required this.place_id,
    this.name,
    this.geometry,
    this.photos,
    this.vicinity,
    this.rating,
  });

  factory NearbyResult.fromJson(Map<String, dynamic> json) =>
      _$NearbyResultFromJson(json);
  Map<String, dynamic> toJson() => _$NearbyResultToJson(this);
}

@JsonSerializable()
class Geometry {
  final Location? location;

  Geometry({this.location});

  factory Geometry.fromJson(Map<String, dynamic> json) =>
      _$GeometryFromJson(json);
  Map<String, dynamic> toJson() => _$GeometryToJson(this);
}

@JsonSerializable()
class Location {
  final double? lat;
  final double? lng;

  Location({this.lat, this.lng});

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

@JsonSerializable()
class Photo {
  @JsonKey(name: 'photo_reference')
  final String? photoReference;

  Photo({this.photoReference});

  factory Photo.fromJson(Map<String, dynamic> json) =>
      _$PhotoFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}