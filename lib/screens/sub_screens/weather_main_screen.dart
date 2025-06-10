import 'package:flutter/material.dart';
import 'package:lumo_ai_travel_plan_app/api/weather_api_services/country_city_service.dart';
import 'package:lumo_ai_travel_plan_app/api/weather_api_services/weather_service.dart';
import 'package:lumo_ai_travel_plan_app/api/weather_models/city_response.dart';
import 'package:lumo_ai_travel_plan_app/api/weather_models/country_response.dart';
import 'package:lumo_ai_travel_plan_app/api/weather_models/forecast_response.dart';

import '../../api/weather_models/weather_response.dart';

class WeatherMainScreen extends StatefulWidget {
  const WeatherMainScreen({super.key});

  @override
  State<WeatherMainScreen> createState() => _WeatherMainScreenState();
}

class _WeatherMainScreenState extends State<WeatherMainScreen> {
  final CountryCityService _countryCityService = CountryCityService.create();
  final WeatherService _weatherService = WeatherService.create();

  late Future<CountryResponse> _countryResponse;
  Future<CityResponse>? _cityResponse;

  WeatherResponse? _currentWeather;
  List<ForecastItem> _forecastList = [];

  String? _selectedCountryCode;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _fetchCities("JP");
  }

  // 取得國家列表
  // Future<void> _fetchCountries(int limit) async{
  //   setState(() {
  //     _countryResponse = _countryCityService.fetchCountries(10);
  //   });
  // }

  // 取得程式列表
  Future<void> _fetchCities(String countryCode) async {
    setState(() {
      _cityResponse = _countryCityService.fetchCities(countryCode, 10);
    });
  }

  // 取得城式天氣狀態
  Future<void> _fetchWeather(String city) async {
    try {
      final current = await _weatherService.fetchCurrentWeather(city, "metric", "zh_tw");
      final forecast = await _weatherService.fetchForecast(city, "metric", "zh_tw");

      setState(() {
        _currentWeather = current;
        _forecastList = forecast.list.where((item) => item.dateTime.contains("12:00:00")).toList();
      });
    } catch (e) {
      print('Fetch weather error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('資料載入失敗，請稍後再試'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 國家列表
                  // FutureBuilder<CountryResponse>(
                  //   future: _countryResponse,
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return const CircularProgressIndicator();
                  //     } else if (snapshot.hasError) {
                  //       return Text('Error: ${snapshot.error}');
                  //     } else if (snapshot.hasData) {
                  //       final countries = snapshot.data!.data;
                  //       return _buildCountryDropdown(countries);
                  //     } else {
                  //       return const Text('No countries available');
                  //     }
                  //   },
                  // ),
                  const SizedBox(height: 16),
                  // 城市列表
                  if (_cityResponse != null)
                    FutureBuilder<CityResponse>(
                      future: _cityResponse,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          final cities = snapshot.data!.data;
                          return _buildCityDropdown(cities);
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  const SizedBox(height: 24),
                  if (_currentWeather != null) _buildCurrentWeather(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 國家列表下拉式選單
  Widget _buildCountryDropdown(List<Country> countries) {
    return DropdownButton<String>(
      hint: const Text('Select country'),
      value: _selectedCountryCode,
      isExpanded: true,
      items: countries.map((country) {
        return DropdownMenuItem(
          value: country.code,
          child: Text(country.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCountryCode = value;
          _selectedCity = null;
          _currentWeather = null;
        });
        if (value != null) {
          _fetchCities(value);
        }
      },
    );
  }

  Widget _buildCityDropdown(List<City> cities) {
    return DropdownButton<String>(
      hint: const Text('Select city'),
      value: _selectedCity,
      isExpanded: true,
      items: cities.map((city) {
        return DropdownMenuItem(
          value: city.name,
          child: Text(city.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCity = value;
        });
        if (value != null) {
          _fetchWeather(value);
        }
      },
    );
  }

  Widget _buildCurrentWeather() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _currentWeather!.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Image.network(
              'https://openweathermap.org/img/wn/${_currentWeather!.weather[0].icon}@2x.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 12),
            Text(
              '${_currentWeather!.main.temp.toStringAsFixed(1)}°C',
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 8),
            Text(_currentWeather!.weather[0].description),
            const SizedBox(height: 8),
            Text('最高: ${_currentWeather!.main.tempMax}°C 最低: ${_currentWeather!.main.tempMin}°C'),
            Text('濕度: ${_currentWeather!.main.humidity}% 風速: ${_currentWeather!.wind.speed} m/s'),
            const SizedBox(height: 12,),
            _buildForecastCarousel(),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastCarousel() {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        itemCount: _forecastList.length,
        controller: PageController(viewportFraction: 0.8),
        itemBuilder: (context, index) {
          final forecast = _forecastList[index];
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Card(
              key: ValueKey(forecast.dateTime),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      forecast.dateTime.substring(5, 16), // MM-DD HH:mm
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Image.network(
                      'https://openweathermap.org/img/wn/${forecast.weather[0].icon}@2x.png',
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(height: 12),
                    Text('${forecast.main.temp.toStringAsFixed(1)}°C', style: const TextStyle(fontSize: 24)),
                    Text(forecast.weather[0].description),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
