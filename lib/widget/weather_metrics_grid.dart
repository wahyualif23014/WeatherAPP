// widgets/weather_metrics_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'glassmorphic_card.dart';

class WeatherMetricsGrid extends StatefulWidget {
  @override
  _WeatherMetricsGridState createState() => _WeatherMetricsGridState();
}

class _WeatherMetricsGridState extends State<WeatherMetricsGrid>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  final List<WeatherMetric> metrics = [
    WeatherMetric(
      title: "Humidity",
      value: "65%",
      icon: Icons.water_drop,
      color: Colors.blue,
      unit: "%",
      description: "Comfortable",
    ),
    WeatherMetric(
      title: "Wind Speed",
      value: "12",
      icon: Icons.air,
      color: Colors.green,
      unit: "km/h",
      description: "Light breeze",
    ),
    WeatherMetric(
      title: "Pressure",
      value: "1013",
      icon: Icons.speed,
      color: Colors.purple,
      unit: "hPa",
      description: "Normal",
    ),
    WeatherMetric(
      title: "UV Index",
      value: "8",
      icon: Icons.wb_sunny_outlined,
      color: Colors.orange,
      unit: "",
      description: "Very high",
    ),
    WeatherMetric(
      title: "Visibility",
      value: "10",
      icon: Icons.visibility,
      color: Colors.cyan,
      unit: "km",
      description: "Excellent",
    ),
    WeatherMetric(
      title: "Precipitation",
      value: "0",
      icon: Icons.grain,
      color: Colors.indigo,
      unit: "mm",
      description: "No rain",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      metrics.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 800 + (index * 100)),
        vsync: this,
      ),
    );
    
    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ));
    }).toList();
    
    _startAnimations();
  }

  void _startAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 15),
          child: Text(
            "Weather Details",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemCount: metrics.length,
          itemBuilder: (context, index) {
            return AnimatedBuilder(
              animation: _animations[index],
              builder: (context, child) {
                return Transform.scale(
                  scale: _animations[index].value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - _animations[index].value)),
                    child: Opacity(
                      opacity: _animations[index].value,
                      child: _buildMetricCard(metrics[index], index),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildMetricCard(WeatherMetric metric, int index) {
    return AnimatedGlassmorphicCard(
      padding: const EdgeInsets.all(16),
      onTap: () {
        HapticFeedback.lightImpact();
        _controllers[index].reverse().then((_) {
          _controllers[index].forward();
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: metric.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  metric.icon,
                  color: metric.color,
                  size: 24,
                ),
              ),
              Text(
                metric.unit,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Text(
            metric.title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                metric.value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              if (metric.unit.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2, left: 2),
                  child: Text(
                    metric.unit,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          
          Text(
            metric.description,
            style: TextStyle(
              fontSize: 12,
              color: metric.color.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherMetric {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String unit;
  final String description;

  WeatherMetric({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.unit,
    required this.description,
  });
}