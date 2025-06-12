import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state_management/weahter_provider.dart';
import '../../widget/weather_display.dart';

class WeatherMainScreen extends StatefulWidget {
  const WeatherMainScreen({super.key});

  @override
  State<WeatherMainScreen> createState() => _WeatherMainScreenState();
}

class _WeatherMainScreenState extends State<WeatherMainScreen> {
  String selectedCity = '臺中市';
  final List<String> cities = ['臺中市', '臺北市', '高雄市'];

  @override
  void initState() {
    super.initState();
    Provider.of<WeatherProvider>(context, listen: false).fetchWeather(selectedCity);
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('天氣查詢')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: selectedCity,
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedCity = value);
                  weatherProvider.fetchWeather(value);
                }
              },
              items: cities.map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            weatherProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : weatherProvider.weatherData != null
                ? WeatherDisplay(data: weatherProvider.weatherData!)
                : const Text("請選擇地區")
          ],
        ),
      ),
    );
  }
}
