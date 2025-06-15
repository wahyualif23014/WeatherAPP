// widgets/weekly_forecast_list.dart
import 'package:flutter/material.dart';
import 'dart:ui';

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
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecastData.length,
        itemBuilder: (context, index) {
          final data = forecastData[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: ForecastItem(data: data),
          );
        },
      ),
    );
  }
}
class ForecastItem extends StatefulWidget{
  final Map<String, dynamic> data;

  const ForecastItem({super.key, required this.data});
  @override
  State<ForecastItem> createState() => _ForecastItemState();
}
class _ForecastItemState extends State<ForecastItem>{
  double _scale =1.0;
  bool _ispressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _ispressed = true;
      _scale = 0.9;
    });
  }
   void _onTapUp(TapUpDetails details) {
    setState(() {
      _ispressed = false;
      _scale = 1.0;
    });
  }
  void _onTapCancel() {
    setState(() {
      _ispressed = false;
      _scale = 1.0;
    });
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Transform.scale(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 100,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
            backgroundBlendMode: BlendMode.multiply,
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                widget.data["day"],
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                widget.data["icon"],
                color: Colors.white,
                size: 30,
              ),
              Text(
                "${widget.data["max"]}° / ${widget.data["min"]}°",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}