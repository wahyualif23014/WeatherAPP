import 'package:flutter/material.dart';
import 'weather_tile.dart';

class WeatherRowGrid extends StatelessWidget {
  const WeatherRowGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const BouncingScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: const [
        WeatherTile(
          title: "UV INDEX",
          value: "4",
          subtitle: "Moderate",
        ),
        WeatherTile(
          title: "SUNRISE",
          value: "5:28 AM",
          subtitle: "Sunset: 7:25PM",
        ),
        WeatherTile(
          title: "WIND",
          value: "9.7 km/h",
          subtitle: "N ↔ S",
        ),
        WeatherTile(
          title: "RAINFALL",
          value: "1.8 mm",
          subtitle: "1.2 mm expected",
        ),
        WeatherTile(
          title: "FEELS LIKE",
          value: "19°",
          subtitle: "Similar to actual",
        ),
        WeatherTile(
          title: "HUMIDITY",
          value: "90%",
          subtitle: "Dew point: 17",
        ),
        WeatherTile(
          title: "VISIBILITY",
          value: "8 km",
          subtitle: "Clear visibility",
        ),
        WeatherTile(
          title: "PRESSURE",
          value: "—",
          subtitle: "Pressure indicator",
        ),
      ],
    );
  }
}
