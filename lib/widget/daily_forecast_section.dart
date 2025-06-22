import 'dart:ui';

import 'package:flutter/material.dart';

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
    final mediaQuery = MediaQuery.of(context);
    final textScaleFactor = mediaQuery.textScaleFactor.clamp(0.8, 1.2); // batasi scaling
    final fontSizeFactor = textScaleFactor * 0.9;

    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 4 * fontSizeFactor),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20 * fontSizeFactor),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.all(16 * fontSizeFactor),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20 * fontSizeFactor),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1 * fontSizeFactor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10 * fontSizeFactor),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.blue, Colors.purple],
                              ),
                              borderRadius:
                                  BorderRadius.circular(12 * fontSizeFactor),
                            ),
                            child: Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                              size: 20 * fontSizeFactor,
                            ),
                          ),
                          SizedBox(width: 12 * fontSizeFactor),
                          Text(
                            '7-Day Forecast',
                            style: TextStyle(
                              fontSize: 16 * fontSizeFactor,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10 * fontSizeFactor,
                          vertical: 4 * fontSizeFactor,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(16 * fontSizeFactor),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          'Daily',
                          style: TextStyle(
                            fontSize: 10 * fontSizeFactor,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16 * fontSizeFactor),
                  ...forecastData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    return GestureDetector(
                      onTap: () => _showBottomSheet(context, data),
                      child: AnimatedBuilder(
                        animation: _itemAnimations[index],
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                              0,
                              20 * (1 - _itemAnimations[index].value),
                            ),
                            child: Opacity(
                              opacity: _itemAnimations[index].value,
                              child: child,
                            ),
                          );
                        },
                        child: _buildDailyForecastItem(data, index == 0, fontSizeFactor),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _showBottomSheet(BuildContext context, DailyWeatherData data) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.black.withOpacity(0.8),
      builder: (context) {
        final textScaleFactor = MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2);

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    data.icon,
                    color: _getIconColor(data.icon),
                    size: 32,
                  ),
                  SizedBox(width: 12),
                  Text(
                    "${data.highTemp}° / ${data.lowTemp}°",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                "${data.condition}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.water_drop, color: Colors.blue),
                  SizedBox(width: 4),
                  Text("${data.rainChance}% chance of rain"),
                ],
              ),
              SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.air, color: Colors.white),
                  SizedBox(width: 4),
                  Text("Wind: ${data.windSpeed} km/h"),
                ],
              ),
              SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.opacity, color: Colors.white),
                  SizedBox(width: 4),
                  Text("Humidity: ${data.humidity}%"),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDailyForecastItem(DailyWeatherData data, bool isToday, double fontSizeFactor) {
    return Container(
      margin: EdgeInsets.only(bottom: 8 * fontSizeFactor),
      padding: EdgeInsets.all(12 * fontSizeFactor),
      decoration: BoxDecoration(
        color: isToday
            ? Colors.white.withOpacity(0.15)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12 * fontSizeFactor),
        border: Border.all(
          color: isToday
              ? Colors.white.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              data.day,
              style: TextStyle(
                fontSize: 14 * fontSizeFactor,
                fontWeight: isToday ? FontWeight.w600 : FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6 * fontSizeFactor),
                  decoration: BoxDecoration(
                    color: _getIconColor(data.icon).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8 * fontSizeFactor),
                  ),
                  child: Icon(
                    data.icon,
                    color: _getIconColor(data.icon),
                    size: 18 * fontSizeFactor,
                  ),
                ),
                SizedBox(width: 10 * fontSizeFactor),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.condition,
                        style: TextStyle(
                          fontSize: 12 * fontSizeFactor,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      if (data.rainChance > 0)
                        Row(
                          children: [
                            Icon(
                              Icons.water_drop,
                              size: 10 * fontSizeFactor,
                              color: Colors.blue.withOpacity(0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${data.rainChance}%',
                              style: TextStyle(
                                fontSize: 10 * fontSizeFactor,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${data.lowTemp}°',
                  style: TextStyle(
                    fontSize: 14 * fontSizeFactor,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 30,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.orange],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${data.highTemp}°',
                  style: TextStyle(
                    fontSize: 14 * fontSizeFactor,
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