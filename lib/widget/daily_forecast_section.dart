// daily_forecast_section.dart
import 'package:flutter/material.dart';
import 'dart:ui';

class DailyForecastSection extends StatefulWidget {
  @override
  _DailyForecastSectionState createState() => _DailyForecastSectionState();
}

class _DailyForecastSectionState extends State<DailyForecastSection>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _itemAnimations;

  final List<DailyWeatherData> forecastData = [
    DailyWeatherData(
      day: 'Today',
      icon: Icons.wb_sunny,
      highTemp: 28,
      lowTemp: 18,
      humidity: 65,
      windSpeed: 12,
      condition: 'Sunny',
      rainChance: 0,
    ),
    DailyWeatherData(
      day: 'Tomorrow',
      icon: Icons.wb_cloudy,
      highTemp: 26,
      lowTemp: 16,
      humidity: 72,
      windSpeed: 8,
      condition: 'Cloudy',
      rainChance: 20,
    ),
    DailyWeatherData(
      day: 'Tuesday',
      icon: Icons.grain,
      highTemp: 24,
      lowTemp: 15,
      humidity: 85,
      windSpeed: 15,
      condition: 'Rainy',
      rainChance: 80,
    ),
    DailyWeatherData(
      day: 'Wednesday',
      icon: Icons.wb_cloudy,
      highTemp: 25,
      lowTemp: 17,
      humidity: 70,
      windSpeed: 10,
      condition: 'Partly Cloudy',
      rainChance: 30,
    ),
    DailyWeatherData(
      day: 'Thursday',
      icon: Icons.wb_sunny,
      highTemp: 29,
      lowTemp: 19,
      humidity: 60,
      windSpeed: 14,
      condition: 'Sunny',
      rainChance: 10,
    ),
    DailyWeatherData(
      day: 'Friday',
      icon: Icons.thunderstorm,
      highTemp: 22,
      lowTemp: 14,
      humidity: 90,
      windSpeed: 20,
      condition: 'Thunderstorm',
      rainChance: 95,
    ),
    DailyWeatherData(
      day: 'Saturday',
      icon: Icons.wb_sunny,
      highTemp: 27,
      lowTemp: 16,
      humidity: 55,
      windSpeed: 11,
      condition: 'Clear',
      rainChance: 5,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _itemAnimations = List.generate(
      forecastData.length,
      (index) => Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1,
          0.8 + (index * 0.1),
          curve: Curves.easeOutCubic,
        ),
      )),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.withOpacity(0.8),
                                Colors.purple.withOpacity(0.6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '7-Day Forecast',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        'Daily',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Daily forecast items
                ...forecastData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  
                  return AnimatedBuilder(
                    animation: _itemAnimations[index],
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          0,
                          30 * (1 - _itemAnimations[index].value),
                        ),
                        child: Opacity(
                          opacity: _itemAnimations[index].value,
                          child: _buildDailyForecastItem(data, index == 0),
                        ),
                      );
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDailyForecastItem(DailyWeatherData data, bool isToday) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isToday 
            ? Colors.white.withOpacity(0.15)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isToday 
              ? Colors.white.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          // Day
          Expanded(
            flex: 2,
            child: Text(
              data.day,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isToday ? FontWeight.w600 : FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          
          // Weather Icon and Condition
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getIconColor(data.icon).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    data.icon,
                    color: _getIconColor(data.icon),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.condition,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      if (data.rainChance > 0) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.water_drop,
                              size: 12,
                              color: Colors.blue.withOpacity(0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${data.rainChance}%',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Temperature
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${data.lowTemp}°',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.5),
                        Colors.orange.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${data.highTemp}°',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getIconColor(IconData icon) {
    switch (icon) {
      case Icons.wb_sunny:
        return Colors.orange;
      case Icons.wb_cloudy:
        return Colors.grey;
      case Icons.grain:
        return Colors.blue;
      case Icons.thunderstorm:
        return Colors.purple;
      default:
        return Colors.white;
    }
  }
}

class DailyWeatherData {
  final String day;
  final IconData icon;
  final int highTemp;
  final int lowTemp;
  final int humidity;
  final int windSpeed;
  final String condition;
  final int rainChance;

  DailyWeatherData({
    required this.day,
    required this.icon,
    required this.highTemp,
    required this.lowTemp,
    required this.humidity,
    required this.windSpeed,
    required this.condition,
    required this.rainChance,
  });
}