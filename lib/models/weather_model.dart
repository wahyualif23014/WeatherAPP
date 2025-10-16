// lib/models/weather_model.dart
class WeatherModel {
  final String locationName;    // kota / lokasi (opsional)
  final double temp;           // current temperature (°C)
  final double feelsLike;      // feels_like (°C)
  final String condition;      // e.g. "Sunny" / "Clear"
  final String icon;           // icon code atau url (opsional)
  final double minTemp;        // daily min (°C)
  final double maxTemp;        // daily max (°C)
  final DateTime timestamp;    // waktu pembacaan
  final String provider;       // "open-meteo" / "openweathermap"

  WeatherModel({
    required this.locationName,
    required this.temp,
    required this.feelsLike,
    required this.condition,
    required this.icon,
    required this.minTemp,
    required this.maxTemp,
    required this.timestamp,
    required this.provider,
  });

  // Common toJson (optional)
  Map<String, dynamic> toJson() => {
        'locationName': locationName,
        'temp': temp,
        'feelsLike': feelsLike,
        'condition': condition,
        'icon': icon,
        'minTemp': minTemp,
        'maxTemp': maxTemp,
        'timestamp': timestamp.toIso8601String(),
        'provider': provider,
      };

  // -----------------------
  // Factory parser: OpenWeatherMap (current weather)
  // OpenWeather example fields: main.temp, main.feels_like, main.temp_min, main.temp_max, weather[0].main, weather[0].icon
  // URL example:
  // https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&units=metric&appid={APIKEY}
  // -----------------------
  factory WeatherModel.fromOpenWeatherMapJson(Map<String, dynamic> json) {
    final main = json['main'] ?? {};
    final weatherList = json['weather'] as List<dynamic>? ?? [];
    final w0 = weatherList.isNotEmpty ? weatherList[0] as Map<String, dynamic> : {};
    return WeatherModel(
      locationName: json['name'] ?? '',
      temp: (main['temp']?.toDouble() ?? 0.0),
      feelsLike: (main['feels_like']?.toDouble() ?? (main['temp']?.toDouble() ?? 0.0)),
      condition: (w0['main'] ?? w0['description'] ?? '').toString(),
      icon: (w0['icon'] ?? '').toString(),
      minTemp: (main['temp_min']?.toDouble() ?? (main['temp']?.toDouble() ?? 0.0)),
      maxTemp: (main['temp_max']?.toDouble() ?? (main['temp']?.toDouble() ?? 0.0)),
      timestamp: DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000),
      provider: 'openweathermap',
    );
  }

  // -----------------------
  // Factory parser: Open-Meteo
  // Open-Meteo returns `current_weather` and `daily` arrays (daily temps arrays).
  // Example call: https://api.open-meteo.com/v1/forecast?latitude=...&longitude=...&current_weather=true&daily=temperature_2m_max,temperature_2m_min&timezone=auto
  // response.current_weather.temperature, response.daily.temperature_2m_max[0], temperature_2m_min[0]
  // weather code -> map to text (optional).
  // -----------------------
  factory WeatherModel.fromOpenMeteoJson(Map<String, dynamic> json, {String locationName = ''}) {
    final current = json['current_weather'] ?? {};
    final daily = json['daily'] ?? {};
    // daily arrays: temperature_2m_max, temperature_2m_min
    double max = 0.0;
    double min = 0.0;
    try {
      final maxList = (daily['temperature_2m_max'] as List<dynamic>?);
      final minList = (daily['temperature_2m_min'] as List<dynamic>?);
      if (maxList != null && maxList.isNotEmpty) max = (maxList[0]?.toDouble() ?? 0.0);
      if (minList != null && minList.isNotEmpty) min = (minList[0]?.toDouble() ?? 0.0);
    } catch (_) {}

    final temp = (current['temperature']?.toDouble() ?? 0.0);
    final weatherCode = current['weathercode'] ?? 0;
    // small helper: map weather code -> text (very simplified)
    String codeToText(int code) {
      if (code == 0) return 'Clear';
      if (code == 1 || code == 2 || code == 3) return 'Partly cloudy';
      if (code >= 80 && code < 90) return 'Rain';
      if (code >= 50 && code < 60) return 'Drizzle/Fog';
      if (code >= 60 && code < 70) return 'Snow/Ice';
      return 'Unknown';
    }

    return WeatherModel(
      locationName: locationName,
      temp: temp,
      feelsLike: temp, // open-meteo current_weather doesn't provide feels_like; keep temp as fallback or compute later.
      condition: codeToText((weatherCode as int)),
      icon: '', // open-meteo gives weathercode only; you can map to local icon assets.
      minTemp: min,
      maxTemp: max,
      timestamp: DateTime.parse(current['time'] ?? DateTime.now().toIso8601String()),
      provider: 'open-meteo',
    );
  }
}
