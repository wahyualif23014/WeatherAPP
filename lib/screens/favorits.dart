// favorite.dart
import 'package:flutter/material.dart';
import '../widget/weather_favorite_card.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteWeatherScreenState();
}

class _FavoriteWeatherScreenState extends State<Favorite> {
  final List<Map<String, dynamic>> favoriteLocations = [
    {
      'city': 'Jakarta',
      'temperature': 32,
      'condition': 'Sunny',
      'icon': Icons.wb_sunny
    },
    {
      'city': 'Tokyo',
      'temperature': 24,
      'condition': 'Cloudy',
      'icon': Icons.cloud
    },
    {
      'city': 'New York',
      'temperature': 18,
      'condition': 'Rainy',
      'icon': Icons.umbrella
    },
    {
      'city': 'Indonesia',
      'temperature': 20,
      'condition': 'Sunny',
      'icon': Icons.wb_sunny,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Weather'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: favoriteLocations.length,
            itemBuilder: (context, index) {
              final location = favoriteLocations[index];
              return WeatherFavoriteCard(
                city: location['city'],
                temperature: location['temperature'],
                condition: location['condition'],
                icon: location['icon'],
              );
            },
          ),
        ),
      ),
    );
  }
}