import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import '../map_models/nearby_detail_response.dart';
import '../map_models/nearby_response.dart';

part 'google_map_api.g.dart';

@RestApi(baseUrl: "https://maps.googleapis.com/maps/api/place/")
abstract class GoogleMapApi {
  factory GoogleMapApi(Dio dio, {String baseUrl}) = _GoogleMapApi;

  // 取得景點資訊
  @GET("nearbysearch/json")
  Future<NearbyResponse> getNearbyPlaces({
    @Query("location") required String location, // ex: "25.0330,121.5654"
    @Query("radius") int radius = 150,
    @Query("type") String type = "tourist_attraction",
    @Query("key") required String apiKey,
    @Query("language") String language = "zh-TW",
  });

  // 取得景點明細
  @GET("details/json")
  Future<NearbyDetailResponse> getPlaceDetail({
    @Query("place_id") required String? placeId,
    @Query("language") String language = "zh-TW",
    @Query("key") required String apiKey,
  });

  // 取得餐廳資訊
  @GET("nearbysearch/json")
  Future<NearbyResponse> getNearbyFood({
    @Query("location") required String location, // ex: "25.0330,121.5654"
    @Query("radius") int radius = 150,
    @Query("type") String type = "restaurant",
    @Query("key") required String apiKey,
    @Query("language") String language = "zh-TW",
  });

  // 取得餐廳明細
  @GET("details/json")
  Future<NearbyDetailResponse> getFoodDetail({
    @Query("place_id") required String? placeId,
    @Query("language") String language = "zh-TW",
    @Query("key") required String apiKey,
  });
}

