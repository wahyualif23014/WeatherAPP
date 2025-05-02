import 'package:flutter/material.dart';

class HourlyWeather {
  final String time;
  final String temperature;
  final Widget weatherIcon;
  final String? chance;
  final bool isNow;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.weatherIcon,
    this.chance,
    this.isNow = false,
  });
}

final List<HourlyWeather> hourlyWeatherData = [
  HourlyWeather(
    time: "12 AM",
    temperature: "19",
    weatherIcon: Icon(Icons.cloud, color: Colors.white, size: 30),
    chance: "30%",
  ),
  HourlyWeather(
    time: "Now",
    temperature: "19",
    weatherIcon: Icon(Icons.cloud_queue, color: Colors.white, size: 30),
    isNow: true,
  ),
  HourlyWeather(
    time: "2 AM",
    temperature: "18",
    weatherIcon: Icon(Icons.cloudy_snowing, color: Colors.white, size: 30),
  ),
  HourlyWeather(
    time: "3 AM",
    temperature: "19",
    weatherIcon: Icon(Icons.cloud, color: Colors.white, size: 30),
  ),
  HourlyWeather(
    time: "4 AM",
    temperature: "19",
    weatherIcon: Icon(Icons.cloud, color: Colors.white, size: 30),
  ),
];
