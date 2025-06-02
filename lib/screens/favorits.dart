import 'package:flutter/material.dart';
import '../widget/weather_favorite_card.dart';

// ignore: must_be_immutable

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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Favorite Weather'),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
      ),
      body: Padding(
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
    );
  }
}
