import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class WeatherModel {

  final String time;
  final String temperature;
  final String chanceOfRain;
  final String condition;

  WeatherModel({
    required this.time,
    required this.temperature,
    required this.chanceOfRain,
    required this.condition,
  });

  IconData get weatherIcon {
    switch (condition) {
      case 'Sunny':
        return Icons.wb_sunny;
      case 'Cloudy':
        return Icons.cloud;
      case 'Rainy':
        return Icons.cloudy_snowing;
      case 'Snowy':
        return Icons.ac_unit;
      default:
        return Icons.wb_sunny;
    }
  }
}