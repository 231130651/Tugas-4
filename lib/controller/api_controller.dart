import 'dart:convert';
import 'package:http/http.dart' as http;

// Ganti dengan API Key Anda yang valid dari WeatherAPI.com
const String apiKey = "269e5eb4326341c28a370111250207";

class WeatherApi {
  final String _baseUrl = "https://api.weatherapi.com/v1";

  // Mengambil data ramalan cuaca untuk 7 hari ke depan
  Future<Map<String, dynamic>> getForecast(String location) async {
    // URL sudah mengambil data untuk 7 hari (days=7)
    final url = Uri.parse(
      "$_baseUrl/forecast.json?key=$apiKey&q=$location&days=7&aqi=no&alerts=no",
    );

    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception("Gagal mengambil data: ${res.body}");
    }
    final data = json.decode(res.body);

    if (data.containsKey("error")) {
      throw Exception(data['error']['message'] ?? "Lokasi tidak valid");
    }
    return data;
  }
}