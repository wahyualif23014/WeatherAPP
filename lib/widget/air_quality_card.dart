import 'package:flutter/material.dart';

class AirQualityCard extends StatelessWidget {
  const AirQualityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade700.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("AIR QUALITY", style: TextStyle(color: Colors.white60, fontSize: 12)),
          const SizedBox(height: 8),
          const Text("3 - Low Health Risk", style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.3,
            color: Colors.pinkAccent,
            backgroundColor: Colors.white24,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Text("See more", style: TextStyle(color: Colors.white70)),
              Icon(Icons.chevron_right, color: Colors.white70),
            ],
          )
        ],
      ),
    );
  }
}
