import 'package:dio/dio.dart';

class ChatGptApi {
  late final Dio dio;

  ChatGptApi(this.dio);

  Future<String> sendPrompt(String prompt, String apiKey) async {
    final response = await dio.post(
      'https://api.openai.com/v1/chat/completions',
      options: Options(
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
      ),
      data: {
        "model": "gpt-4",
        "messages": [
          {"role": "user", "content": prompt}
        ]
      },
    );
    print("taitest chat response: $response");
    return response.data['choices'][0]['message']['content'];
  }
}
