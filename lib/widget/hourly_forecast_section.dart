// widgets/hourly_forecast_section.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'glassmorphic_card.dart';

class HourlyForecastSection extends StatefulWidget {
  @override
  _HourlyForecastSectionState createState() => _HourlyForecastSectionState();
}

class _HourlyForecastSectionState extends State<HourlyForecastSection>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  
  final List<HourlyWeather> hourlyData = [
    HourlyWeather("Now", Icons.wb_sunny, "28°", Colors.orange, 0.8),
    HourlyWeather("14:00", Icons.wb_sunny, "30°", Colors.orange, 0.9),
    HourlyWeather("15:00", Icons.cloud, "29°", Colors.grey, 0.6),
    HourlyWeather("16:00", Icons.cloud, "27°", Colors.grey, 0.7),
    HourlyWeather("17:00", Icons.grain, "25°", Colors.blue, 0.4),
    HourlyWeather("18:00", Icons.thunderstorm, "23°", Colors.purple, 0.3),
    HourlyWeather("19:00", Icons.cloud, "24°", Colors.grey, 0.5),
    HourlyWeather("20:00", Icons.wb_sunny, "26°", Colors.orange, 0.7),
  ];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Hourly Forecast",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  // Navigate to detailed hourly view
                },
                child: Text(
                  "View All",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue.shade300,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        GlassmorphicCard(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: SlideTransition(
            position: _slideAnimation,
            child: SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: hourlyData.length,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _slideController,
                    builder: (context, child) {
                      final delay = index * 0.1;
                      final animationValue = (_slideController.value - delay).clamp(0.0, 1.0);
                      
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - animationValue)),
                        child: Opacity(
                          opacity: animationValue,
                          child: _buildHourlyItem(hourlyData[index], index),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHourlyItem(HourlyWeather weather, int index) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        // Show detailed info for this hour
      },
      child: Container(
        width: 70,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Time
            Text(
              weather.time,
              style: TextStyle(
                fontSize: 12,
                color: weather.time == "Now" 
                    ? Colors.blue.shade300 
                    : Colors.white.withOpacity(0.7),
                fontWeight: weather.time == "Now" 
                    ? FontWeight.w600 
                    : FontWeight.w500,
              ),
            ),
            
            // Weather Icon with Animation
            TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 800 + (index * 100)),
              tween: Tween(begin: 0.0, end: weather.intensity),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: weather.color.withOpacity(0.2 * value),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: weather.color.withOpacity(0.3 * value),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Transform.scale(
                    scale: 0.8 + (0.2 * value),
                    child: Icon(
                      weather.icon,
                      color: weather.color,
                      size: 24,
                    ),
                  ),
                );
              },
            ),
            
            // Temperature
            Text(
              weather.temperature,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ],
              ),
            ),
            
            // Precipitation indicator
            Container(
              width: 30,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.white.withOpacity(0.2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: weather.intensity,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: weather.color.withOpacity(0.8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HourlyWeather {
  final String time;
  final IconData icon;
  final String temperature;
  final Color color;
  final double intensity;

  HourlyWeather(this.time, this.icon, this.temperature, this.color, this.intensity);
}