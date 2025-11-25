import 'dart:convert';
import 'package:http/http.dart' as http;

class GroqService {
  static const String apiKey =
      "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";
  static const String url = "https://api.groq.com/openai/v1/chat/completions";

  static Future<String> askGroq(String message) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "mixtral-8x7b-32768", // FAST + FREE model
        "messages": [
          {"role": "user", "content": message},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["choices"][0]["message"]["content"];
    } else {
      return "Groq API error: ${response.body}";
    }
  }
}
