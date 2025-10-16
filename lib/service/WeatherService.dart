// lib/services/weather_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  // Open-Meteo (no key)
  // Example:
  // https://api.open-meteo.com/v1/forecast?latitude=latitude&longitude=longitude&current_weather=true&daily=temperature_2m_max,temperature_2m_min&timezone=auto
  Future<WeatherModel> fetchFromOpenMeteo({
    required double lat,
    required double lon,
    String locationName = '',
  }) async {
    final url =
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true&daily=temperature_2m_max,temperature_2m_min&timezone=auto';
    final uri = Uri.parse(url);
    final resp = await http.get(uri).timeout(Duration(seconds: 10));
    if (resp.statusCode == 200) {
      final jsonBody = json.decode(resp.body) as Map<String, dynamic>;
      return WeatherModel.fromOpenMeteoJson(jsonBody, locationName: locationName);
    } else {
      throw Exception('OpenMeteo error: ${resp.statusCode}');
    }
  }

  // OpenWeatherMap (requires API key)
  // Example:
  // https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&units=metric&appid={APIKEY}
  Future<WeatherModel> fetchFromOpenWeatherMap({
    required double lat,
    required double lon,
    required String apiKey,
  }) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey';
    final uri = Uri.parse(url);
    final resp = await http.get(uri).timeout(Duration(seconds: 10));
    if (resp.statusCode == 200) {
      final jsonBody = json.decode(resp.body) as Map<String, dynamic>;
      return WeatherModel.fromOpenWeatherMapJson(jsonBody);
    } else {
      throw Exception('OpenWeatherMap error: ${resp.statusCode} ${resp.body}');
    }
  }
}
