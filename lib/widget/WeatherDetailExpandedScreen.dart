import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

class WeatherDetailExpandedScreen extends StatelessWidget {
  const WeatherDetailExpandedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1745521245831-422f7f9140ac?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDN8Ym84alFLVGFFMFl8fGVufDB8fHx8fA%3D%3D',
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black,
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 36,
                    color: Colors.white70,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Jakarta, Indonesia",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Mostly Cloudy",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "27°C",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _weatherDetailItem(Icons.water_drop, "Humidity", "78%"),
                      _weatherDetailItem(Icons.air, "Wind", "12 km/h"),
                      _weatherDetailItem(Icons.thermostat, "Feels Like", "26°C"),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _weatherDetailItem(Icons.wb_sunny, "UV Index", "Low"),
                      _weatherDetailItem(Icons.visibility, "Visibility", "8 km"),
                      _weatherDetailItem(Icons.compress, "Pressure", "1012 hPa"),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_downward),
                    label: const Text("Swipe down to return"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.15),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _weatherDetailItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}