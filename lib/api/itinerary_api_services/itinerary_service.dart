import 'package:dio/dio.dart';
import 'package:lumo_ai_travel_plan_app/api/itinerary_api_services/chat_gpt_api.dart';

class ItineraryService {
  late final ChatGptApi api;

  ItineraryService._internal(this.api);

  factory ItineraryService.create() {
    final dio = Dio();
    return ItineraryService._internal(ChatGptApi(dio));
  }

  Future<String> fetchItinerary({
    required String location,
    required String days,
    required List<String> interests,
    required String? apiKey,
  }) async {
    final prompt = '幫我安排$days天的$location旅遊行程，我喜歡${interests.join("、")}，請列出每天的行程、每個景點的簡介、交通建議與用餐地點，格式清楚易讀。';
    return await api.sendPrompt(prompt, apiKey!);
  }
}
