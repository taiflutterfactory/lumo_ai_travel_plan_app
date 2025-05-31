import 'package:flutter/material.dart';
import 'package:lumo_ai_travel_plan_app/api/weather_api_services/country_city_service.dart';
import 'package:lumo_ai_travel_plan_app/api/weather_api_services/weather_service.dart';
import 'package:lumo_ai_travel_plan_app/api/weather_models/city_response.dart';
import 'package:lumo_ai_travel_plan_app/api/weather_models/country_response.dart';
import 'package:lumo_ai_travel_plan_app/api/weather_models/forecast_response.dart';

import '../../api/weather_models/weather_response.dart';
import '../../globals.dart' as globals;

class WeatherMainScreen extends StatefulWidget {
  const WeatherMainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _WeatherMainScreenState();
}

class _WeatherMainScreenState extends State<WeatherMainScreen> {
  final String apiKey = globals.weatherApiKey;
  final CountryCityService _countryCityService = CountryCityService.create();
  final WeatherService _weatherService = WeatherService.create();
  late Future<CountryResponse> _countryResponse;
  Future<CityResponse>? _cityResponse;

  WeatherResponse? _currentWeather;
  List<ForecastItem> _forecastList = [];
  List<Country> _countries = [];
  List<String> _cities = [];

  String? _selectedCountry;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    setState(() {
      _countryResponse = _countryCityService.fetchCountries(10);
    });
  }

  List<Color> getGradientColors(String description) {
    if (description.contains('雨')) {
      return [const Color(0xFF616161), const Color(0xFF9E9E9E)];
    } else if (description.contains('晴')) {
      return [const Color(0xFF89F7FE), const Color(0xFF66A6FF)];
    } else if (description.contains('雲')) {
      return [const Color(0xFFB0BEC5), const Color(0xFFECEFF1)];
    } else if (description.contains('雪')) {
      return [const Color(0xFFE0F7FA), const Color(0xFFB2EBF2)];
    } else {
      return [const Color(0xFFCE93D8), const Color(0xFFBA68C8)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColors = _currentWeather != null
      ? getGradientColors(_currentWeather!.weather[0].description)
      : [const Color(0xFF89F7FE), const Color(0xFF66A6FF)];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: bgColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                FutureBuilder(
                  future: _countryResponse,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      _countries = snapshot.data!.data;
                      print("taitest _countries: $_countries");
                      return _buildCountryDropdown();
                    } else {
                      return const Text('No countries available');
                    }
                  },
                ),
                const SizedBox(height: 16,),
                FutureBuilder(
                  future: _cityResponse,  // 使用 _cityResponse
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      // 更新 _cities
                      _cities = snapshot.data!.data.map((city) => city.name).toList();
                      return _buildCityDropdown();
                    } else {
                      return const Text('');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountryDropdown() {
    print("taitest _selectedCountry: $_selectedCountry");
    return DropdownButton(
      hint: const Text('Select country'),
      value: _selectedCountry,
      isExpanded: true,
      items: _countries.map((countryData) {
        return DropdownMenuItem(
          value: countryData.code,
          child: Text(countryData.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCountry = value;
        });
        if (value != null) {
          _cityResponse = _countryCityService.fetchCities(value, 10);
        }
      },
    );
  }

  Widget _buildCityDropdown() {
    return DropdownButton(
      hint: const Text('Select city'),
      value: _selectedCity,
      isExpanded: true,
      items: _cities.map((city) {
        return DropdownMenuItem(
          value: city,
          child: Text(city),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCity = value;
        });
        if (value != null) {
          _countryCityService.fetchCities(value, 10);
        }
      },
    );
  }
}
