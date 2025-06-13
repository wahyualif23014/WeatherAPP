// sunrise_sunset_section.dart
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class SunriseSunsetSection extends StatefulWidget {
  @override
  _SunriseSunsetSectionState createState() => _SunriseSunsetSectionState();
}

class _SunriseSunsetSectionState extends State<SunriseSunsetSection>
    with TickerProviderStateMixin {
  late AnimationController _sunAnimationController;
  late AnimationController _glowAnimationController;
  late Animation<double> _sunAnimation;
  late Animation<double> _glowAnimation;

  final String sunriseTime = "06:24";
  final String sunsetTime = "18:42";
  final String currentTime = "14:30";

  @override
  void initState() {
    super.initState();
    _sunAnimationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    
    _glowAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _sunAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sunAnimationController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _sunAnimationController.dispose();
    _glowAnimationController.dispose();
    super.dispose();
  }

  double _getSunPosition() {

    int sunriseMinutes = 6 * 60 + 24;
    int sunsetMinutes = 18 * 60 + 42; 
    int currentMinutes = 14 * 60 + 30; 
    
    if (currentMinutes < sunriseMinutes) return 0.0;
    if (currentMinutes > sunsetMinutes) return 1.0;
    
    return (currentMinutes - sunriseMinutes) / (sunsetMinutes - sunriseMinutes);
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
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.withOpacity(0.8),
                            Colors.deepOrange.withOpacity(0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.wb_sunny_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Sun & Moon',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                AnimatedBuilder(
                  animation: Listenable.merge([_sunAnimation, _glowAnimation]),
                  builder: (context, child) {
                    return Container(
                      height: 120,
                      child: CustomPaint(
                        size: Size(double.infinity, 120),
                        painter: SunArcPainter(
                          sunPosition: _getSunPosition(),
                          animationValue: _sunAnimation.value,
                          glowValue: _glowAnimation.value,
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 24),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTimeInfo(
                      icon: Icons.wb_twilight,
                      label: 'Sunrise',
                      time: sunriseTime,
                      color: Colors.orange,
                    ),
                    _buildTimeInfo(
                      icon: Icons.nights_stay,
                      label: 'Sunset',
                      time: sunsetTime,
                      color: Colors.deepPurple,
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Daylight Duration',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      Text(
                        '12h 18m',
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
          ),
        ),
      ),
    );
  }

  Widget _buildTimeInfo({
    required IconData icon,
    required String label,
    required String time,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class SunArcPainter extends CustomPainter {
  final double sunPosition;
  final double animationValue;
  final double glowValue;

  SunArcPainter({
    required this.sunPosition,
    required this.animationValue,
    required this.glowValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height);
    final radius = size.width * 0.4;

    final arcPath = Path();
    arcPath.addArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
    );

    paint.color = Colors.white.withOpacity(0.3);
    canvas.drawPath(arcPath, paint);

    final sunAngle = math.pi + (sunPosition * math.pi);
    final sunX = center.dx + radius * math.cos(sunAngle);
    final sunY = center.dy + radius * math.sin(sunAngle);
    final sunCenter = Offset(sunX, sunY);

    final glowPaint = Paint()
      ..color = Colors.orange.withOpacity(0.3 * glowValue)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(sunCenter, 20 * glowValue, glowPaint);

    final sunPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(sunCenter, 8, sunPaint);

    final horizonPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1;
    
    canvas.drawLine(
      Offset(0, center.dy),
      Offset(size.width, center.dy),
      horizonPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}