import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../weather_models/city_response.dart';
import '../weather_models/country_response.dart';

part 'country_city_api.g.dart';

@RestApi(baseUrl: 'https://wft-geo-db.p.rapidapi.com/v1/geo/')
abstract class CountryCityApi {
  factory CountryCityApi(Dio dio, {String baseUrl}) = _CountryCityApi;

  @GET('countries')
  Future<CountryResponse> getCountries(
    @Query('limit') int limit,
  );

  @GET('cities')
  Future<CityResponse> getCitiesByCountry(
    @Query('countryIds') String countryId,
    @Query('limit') int limit,
    @Query('lang') int lang
  );
}
