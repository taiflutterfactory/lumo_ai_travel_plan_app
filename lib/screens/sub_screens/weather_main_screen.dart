import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lumo_ai_travel_plan_app/api/weather_models/weather_response.dart';
import '../../api/weather_api_services/weather_service.dart';
import '../../globals.dart' as globals;


class WeatherMainScreen extends StatefulWidget {
  const WeatherMainScreen({super.key});

  @override
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

  @override
  void initState() {
    super.initState();
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
    }
  }

  @override
  Widget build(BuildContext context) {
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
        ),
      ),
    );
  }
}
