import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String time;
  final String temperature;
  final IconData icon;
  final String condition;

  const WeatherCard({
    Key? key,
    required this.time,
    required this.temperature,
    required this.icon,
    required this.condition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 125, 122, 129),
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), 
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(time, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          Icon(icon, size: 40, color: Colors.blue),
          const SizedBox(height: 10),
          Text(temperature, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 5),
          Text(condition, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}