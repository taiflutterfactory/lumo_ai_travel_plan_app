import 'package:flutter/cupertino.dart';

import '../api/itinerary_api_services/itinerary_service.dart';

class ItineraryProvider with ChangeNotifier {
  bool isLoading = false;
  String? itineraryResult;
  final ItineraryService _itineraryService = ItineraryService.create();

  Future<void> generateItinerary({
    required String location,
    required String days,
    required List<String> interests,
    String? apiKey,
  }) async {
    isLoading = true;
    itineraryResult = null;
    notifyListeners();

    try {
      itineraryResult = await _itineraryService.fetchItinerary(
          location: location,
          days: days,
          interests: interests,
          apiKey: apiKey
      );
    } catch (e) {
      itineraryResult = 'Error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<String> get parsedDays {
    if (itineraryResult == null) return [];
    final lines = itineraryResult!.split('\n');
    List<String> days = [];
    String buffer = '';
    for (final line in lines) {
      if (line.trim().startsWith("Day") || line.contains("第") && line.contains("天")) {
        if (buffer.isNotEmpty) days.add(buffer.trim());
        buffer = line;
      } else {
        buffer += '\n$line';
      }
    }
    if (buffer.isNotEmpty) days.add(buffer.trim());
    return days;
  }
}
