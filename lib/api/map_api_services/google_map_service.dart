import 'package:dio/dio.dart';
import 'package:lumo_ai_travel_plan_app/api/map_models/nearby_response.dart';

import '../map_models/nearby_detail_response.dart';
import 'google_map_api.dart';

class GoogleMapService {
  late final GoogleMapApi api;

  GoogleMapService._internal(this.api);

  factory GoogleMapService.create() {
    final dio = Dio();
    return GoogleMapService._internal(GoogleMapApi(dio));
  }

  Future<NearbyResponse> fetchNearbyPlace(double lat, double lng,
      String apiKey) async {
    final location = "$lat,$lng"; // 建議不要有空格

    final result = await api.getNearbyPlaces(
        location: location, apiKey: apiKey);

    return result;
  }

  Future<NearbyDetailResponse> fetchNearbyPlaceDetail(String? placeId, String apiKey) async {
    final result = await api.getPlaceDetail(
        placeId: placeId, apiKey: apiKey);
    return result;
  }

  Future<NearbyResponse> fetchNearbyFood(double lat, double lng,
      String apiKey) async {
    final location = "$lat,$lng"; // 建議不要有空格

    final result = await api.getNearbyFood(
        location: location, apiKey: apiKey);

    return result;
  }

  Future<NearbyDetailResponse> fetchNearbyFoodDetail(String? placeId, String apiKey) async {
    final result = await api.getFoodDetail(
        placeId: placeId, apiKey: apiKey);
    return result;
  }
}