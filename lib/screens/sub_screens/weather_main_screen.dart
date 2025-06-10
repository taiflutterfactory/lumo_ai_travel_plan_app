<<<<<<< HEAD
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lumo_ai_travel_plan_app/api/weather_models/weather_response.dart';
import '../../api/weather_api_services/weather_service.dart';
import '../../globals.dart' as globals;

=======
import 'package:flutter/material.dart';
import 'package:lumo_ai_travel_plan_app/api/weather_api_services/country_city_service.dart';
import 'package:lumo_ai_travel_plan_app/api/weather_api_services/weather_service.dart';
import 'package:lumo_ai_travel_plan_app/api/weather_models/city_response.dart';
import 'package:lumo_ai_travel_plan_app/api/weather_models/country_response.dart';
import 'package:lumo_ai_travel_plan_app/api/weather_models/forecast_response.dart';

import '../../api/weather_models/weather_response.dart';
import '../../globals.dart' as globals;
>>>>>>> 9e2293553c76cc52d647f02890f2db86185d8a19

class WeatherMainScreen extends StatefulWidget {
  const WeatherMainScreen({super.key});

  @override
<<<<<<< HEAD
  State<WeatherMainScreen> createState() => _WeatherMainScreen();
}

class _WeatherMainScreen extends State<WeatherMainScreen> {
  final WeatherService _weatherService = WeatherService.create();
  final String _weatherApiKey = globals.weatherApiKey;

  final List<String> _cities = [
    '臺北市', '新北市', '桃園市', '臺中市', '臺南市', '高雄市',
    '基隆市', '新竹市', '嘉義市', '新竹縣', '苗栗縣', '彰化縣',
    '南投縣', '雲林縣', '嘉義縣', '屏東縣', '宜蘭縣', '花蓮縣',
    '臺東縣', '金門縣', '澎湖縣', '連江縣',
  ];

  late String _selectedCity = '臺中市';
  late Future<WeatherResponse> _weatherFuture;
=======
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
>>>>>>> 9e2293553c76cc52d647f02890f2db86185d8a19

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _fetchWeather();
  }

  void _fetchWeather() {
    setState(() {
      _weatherFuture = _weatherService.fetchWeather(_selectedCity, _weatherApiKey);
    });
  }

  // 轉換時間格式
  String formatTime(String timeStr) {
    final dateTime = DateTime.parse(timeStr);
    return DateFormat('MM/dd HH:mm').format(dateTime);
  }

  String getWeatherIcon(String description) {
    if (description.contains('雨')) {
      return '🌧️';
    } else if (description.contains('晴')) {
      return '☀️';
    } else if (description.contains('雲')) {
      return '⛅';
    } else if (description.contains('陰')) {
      return '☁️';
    } else {
      return '🌈';
=======
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
>>>>>>> 9e2293553c76cc52d647f02890f2db86185d8a19
    }
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton(
              value: _selectedCity,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCity = value;
                  });
                  _fetchWeather();
                }
              },
              items: _cities.map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city)
                );
              }).toList(),
            ),
            const SizedBox(height: 20,),
            Expanded(
              child: FutureBuilder<WeatherResponse>(
                future: _weatherFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError){
                    return const Center(child: Text('Loading fail, please wait a minuting'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('No data!'));
                  } else {
                    final location = snapshot.data!.records.location.first;

                    // 取天氣描述 Wx，最高溫度 MaxT
                    final weatherElementList = location.weatherElement;

                    final weatherDescriptionElement = weatherElementList.firstWhere(
                      (element) => element.elementName == 'Wx',
                    );
                    final temperatureElement = weatherElementList.firstWhere(
                      (element) => element.elementName == 'MaxT',
                    );

                    final int itemCount = min(
                      weatherDescriptionElement.time.length,
                      temperatureElement.time.length,
                    );

                    return ListView.builder(
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        final time = weatherDescriptionElement.time[index];
                        final temp = temperatureElement.time[index];

                        return Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Text(
                              getWeatherIcon(time.parameter.parameterName),
                              style: const TextStyle(fontSize: 32),
                            ),
                            title: Text(
                              formatTime(time.startTime),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(time.parameter.parameterName),
                            trailing: Text(
                              '${temp.parameter.parameterName}°C',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }
                    );
                  }
                },
              )
            )
          ],
=======
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
>>>>>>> 9e2293553c76cc52d647f02890f2db86185d8a19
        ),
      ),
    );
  }
<<<<<<< HEAD
=======

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
>>>>>>> 9e2293553c76cc52d647f02890f2db86185d8a19
}
