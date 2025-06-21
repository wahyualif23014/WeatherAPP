import 'package:flutter/material.dart';
import '../widget/weather_favorite_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteWeatherScreenState();
}

class _FavoriteWeatherScreenState extends State<Favorite> {
  late List<FavoriteLocation> favoriteLocations = [];

  Future<void> _loadSavedFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList("favorites") ?? [];

    setState(() {
      favoriteLocations = favorites.map((json) {
        final parts = json.split(",");
        return FavoriteLocation(
          name: parts[0],
          lat: double.parse(parts[1]),
          lng: double.parse(parts[2]),
        );
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSavedFavorites();
  }

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
        decoration: BoxDecoration(
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
          child: favoriteLocations.isEmpty
              ? Center(
                  child: Text(
                    "There is no favorite location yet",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: favoriteLocations.length,
                  itemBuilder: (context, index) {
                    final location = favoriteLocations[index];
                    return WeatherFavoriteCard(
                      city: location.name,
                      temperature: 25, // Ambil dari API jika mau
                      condition: "Cloudy",
                      icon: Icons.wb_cloudy,
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class FavoriteLocation {
  final String name;
  final double lat;
  final double lng;

  FavoriteLocation({
    required this.name,
    required this.lat,
    required this.lng,
  });

  @override
  String toString() => "$name,$lat,$lng";
}