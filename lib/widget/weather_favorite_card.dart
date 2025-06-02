import 'package:flutter/material.dart';

class WeatherFavoriteCard extends StatefulWidget {
  final String city;
  final int temperature;
  final String condition;
  final IconData icon;

  const WeatherFavoriteCard({
    super.key,
    required this.city,
    required this.temperature,
    required this.condition,
    required this.icon,
  });

  @override
  State<WeatherFavoriteCard> createState() => _WeatherFavoriteCardState();
}

class _WeatherFavoriteCardState extends State<WeatherFavoriteCard> {
  bool isExpanded = false;

  void toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleExpand,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(widget.icon, color: Colors.amber, size: 32),
                const SizedBox(width: 16),
                Text(
                  widget.city,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${widget.temperature}°C',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 10),
              Text(
                'Condition: ${widget.condition}',
                style: const TextStyle(color: Colors.white60, fontSize: 16),
              ),
              const SizedBox(height: 5),
              const Text(
                'Swipe down for more details.',
                style: TextStyle(color: Colors.white38, fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
