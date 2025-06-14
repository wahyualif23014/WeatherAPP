import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'glassmorphic_card.dart';
import 'dart:math' as math;

class AirQualitySection extends StatefulWidget {
  @override
  _AirQualitySectionState createState() => _AirQualitySectionState();
}

class _AirQualitySectionState extends State<AirQualitySection>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
  
  final int aqiValue = 42; 
  final double maxAqi = 300;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _progressAnimation = Tween<double>(
      begin: 0,
      end: aqiValue / maxAqi,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _progressController.forward();
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Color _getAqiColor(int aqi) {
    if (aqi <= 50) return Colors.green;
    if (aqi <= 100) return Colors.yellow;
    if (aqi <= 150) return Colors.orange;
    if (aqi <= 200) return Colors.red;
    if (aqi <= 300) return Colors.purple;
    return Colors.brown;
  }

  String _getAqiLabel(int aqi) {
    if (aqi <= 50) return "Good";
    if (aqi <= 100) return "Moderate";
    if (aqi <= 150) return "Unhealthy for Sensitive";
    if (aqi <= 200) return "Unhealthy";
    if (aqi <= 300) return "Very Unhealthy";
    return "Hazardous";
  }

  @override
  Widget build(BuildContext context) {
    final aqiColor = _getAqiColor(aqiValue);
    final aqiLabel = _getAqiLabel(aqiValue);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 15),
          child: Text(
            "Air Quality",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
        AnimatedGlassmorphicCard(
          onTap: () {
            HapticFeedback.mediumImpact();
            _progressController.reset();
            _progressController.forward();
          },
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: aqiColor.withOpacity(0.1),
                                boxShadow: [
                                  BoxShadow(
                                    color: aqiColor.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      
                      AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return CustomPaint(
                            size: const Size(100, 100),
                            painter: AqiCircularProgressPainter(
                              progress: _progressAnimation.value,
                              color: aqiColor,
                            ),
                          );
                        },
                      ),
                      
                      // AQI Value
                      AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          final displayValue = (aqiValue * _progressAnimation.value).round();
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                displayValue.toString(),
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: aqiColor,
                                ),
                              ),
                              Text(
                                "AQI",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.7),
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(width: 20),
              
              // AQI Details
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: aqiColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          aqiLabel,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      "Air quality is considered satisfactory for most people.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                        height: 1.4,
                      ),
                    ),
                    
                    const SizedBox(height: 15),
                    
                    // Pollutants
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildPollutantInfo("PM2.5", "12", Colors.green),
                        _buildPollutantInfo("PM10", "18", Colors.green),
                        _buildPollutantInfo("O₃", "45", Colors.orange),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPollutantInfo(String name, String value, Color color) {
    return Column(
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withOpacity(0.4),
              width: 1,
            ),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class AqiCircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  
  AqiCircularProgressPainter({required this.progress, required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    
    // Background arc
    final backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    
    canvas.drawCircle(center, radius, backgroundPaint);
    
    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    
    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}