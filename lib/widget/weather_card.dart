import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String time;
  final String temperature;
  final String? chance; 
  final Widget icon;
  final bool isNow;

  const WeatherCard({
    Key? key,
    required this.time,
    required this.temperature,
    required this.icon,
    this.chance,
    this.isNow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color gradientStart = isNow
        ? const Color(0xFF5B3BB2) 
        : const Color(0xFF3F2A78);
    final Color gradientEnd = isNow
        ? const Color(0xFF7C4DFF)
        : const Color(0xFF5D3FBF);

    return Container(
      width: 65,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [gradientStart, gradientEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isNow ? "Now" : time,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          icon,
          const SizedBox(height: 4),
          if (chance != null)
            Text(
              chance!,
              style: const TextStyle(
                color: Colors.cyanAccent,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 4),
          Text(
            "$temperature°",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
