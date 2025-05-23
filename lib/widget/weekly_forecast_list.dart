// widgets/weekly_forecast_list.dart
import 'package:flutter/material.dart';

class WeeklyForecastList extends StatelessWidget {
  const WeeklyForecastList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> forecastData = [
      {"day": "Sen", "icon": Icons.wb_sunny, "max": 32, "min": 24},
      {"day": "Sel", "icon": Icons.cloud, "max": 30, "min": 23},
      {"day": "Rab", "icon": Icons.beach_access, "max": 28, "min": 22},
      {"day": "Kam", "icon": Icons.flash_on, "max": 31, "min": 25},
      {"day": "Jum", "icon": Icons.cloud_queue, "max": 29, "min": 24},
      {"day": "Sab", "icon": Icons.wb_sunny, "max": 33, "min": 26},
      {"day": "Min", "icon": Icons.ac_unit, "max": 27, "min": 21},
    ];

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecastData.length,
        itemBuilder: (context, index) {
          final data = forecastData[index];
          return Container(
            width: 100,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.deepPurple[700],
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  data["day"],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  data["icon"],
                  color: Colors.white,
                  size: 30,
                ),
                Text(
                  "${data["max"]}° / ${data["min"]}°",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
