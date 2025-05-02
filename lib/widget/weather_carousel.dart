import 'package:flutter/material.dart';
import '../widget/weather_card.dart';
import '/utils/hourly_model.dart';

class WeatherCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hourlyWeatherData.length,
        itemBuilder: (context, index) {
          final weather = hourlyWeatherData[index];
          return WeatherCard(
            time: weather.time,
            temperature: weather.temperature,
            icon: weather.weatherIcon,
            condition: weather.condition,
          );
        },
      ),
    );
  }
}
