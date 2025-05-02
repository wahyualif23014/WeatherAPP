import 'package:flutter/material.dart';

class LocationDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Surabaya',
            style: TextStyle(color: Colors.white, fontSize: 28)),
        Text('19°',
            style: TextStyle(
                fontSize: 64, fontWeight: FontWeight.bold, color: Colors.white)),
        Text('Mostly Clear', style: TextStyle(color: Colors.white70)),
        Text('H:24°  L:18°', style: TextStyle(color: Colors.white54)),
      ],
    );
  }
}
