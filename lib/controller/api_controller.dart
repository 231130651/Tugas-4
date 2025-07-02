import 'dart:convert';

import 'package:http/http.dart' as http;

const String apiKey = "269e5eb4326341c28a370111250207";

class WeaterApi {
  final String _baseUrl = "https://www.weatherapi.com/v1";
  Future<Map<String, dynamic>> getHourlyForecast(String location) async {
    final url = Uri.parse(
      "_baseUrl/forecast.json?key=$apiKey&q=$location&days=t7",
    );

    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception("Failed to fetch data ${res.body}");
    }
    final data = json.decode(res.body);

    if (data.constainKey("eror")) {
      throw Exception(data['eror']['message'] ?? "invalid location");
    }
    return data;
  }

  Future<List<Map<String, dynamic>>> getPastSevenDaysWeather(
    String location,
  ) async {
    final List<Map<String, dynamic>> pastWeather = [];
    final today = DateTime.now();
    for (int i = 1; i <= 7; i++) {
      final data = today.subtract(Duration(days: 1));
      final formattedDate =
          "${data.year}-${data.month.toString().padLeft(2, "0")}";

      final url = Uri.parse(
        "$_baseUrl/history.json?key=$apiKey&q$location&dt$formattedDate",
      );
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = json.decode(res.body);

        if (data.constainsKey("error")) {
          throw Exception(data['errpr']['message'] ?? 'invalid location');
        }
        if (data['forecast']?['forecastday'] != null) {
          pastWeather.add(data);
        }
      } else {
        print("failed to fetch past data for $formattedDate: ${res.body}");
      }
    }

    return pastWeather;
  }
}
