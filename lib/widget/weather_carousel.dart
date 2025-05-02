import 'package:flutter/material.dart';
import '../widget/weather_card.dart';
import '/utils/hourly_model.dart';

class WeatherCarousel extends StatefulWidget {
  const WeatherCarousel({super.key});

  @override
  State<WeatherCarousel> createState() => _WeatherCarouselState();
}

class _WeatherCarouselState extends State<WeatherCarousel> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130, 
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hourlyWeatherData.length,
        itemBuilder: (context, index) {
          final weather = hourlyWeatherData[index];
          return WeatherCard(
            time: weather.time,
            temperature: weather.temperature,
            icon: weather.weatherIcon,
            chance: weather.chance,
            isNow: weather.isNow,
          );
        },
      ),
    );
  }
}
