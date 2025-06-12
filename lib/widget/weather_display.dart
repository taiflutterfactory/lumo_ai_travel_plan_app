import 'package:flutter/material.dart';
import '../api/weather_models/weather_response.dart';

class WeatherDisplay extends StatelessWidget {
  final WeatherResponse data;
  const WeatherDisplay({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final location = data.records.locations.first.location.first;

    final temp = location.weatherElement
        .firstWhere((e) => e.elementName == 'T')
        .time
        .first
        .elementValue
        .value;

    final description = location.weatherElement
        .firstWhere((e) => e.elementName == 'Wx')
        .time
        .first
        .elementValue
        .value;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(location.locationName, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Text("天氣狀況：$description"),
            Text("溫度：$temp °C"),
          ],
        ),
      ),
    );
  }
}
