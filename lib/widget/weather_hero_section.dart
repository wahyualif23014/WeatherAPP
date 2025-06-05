// widgets/weather_hero_section.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'glassmorphic_card.dart';

class WeatherHeroSection extends StatefulWidget {
  @override
  _WeatherHeroSectionState createState() => _WeatherHeroSectionState();
}

class _WeatherHeroSectionState extends State<WeatherHeroSection>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _bounceController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _bounceAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));
    
    _bounceController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedGlassmorphicCard(
      onTap: () {
        HapticFeedback.mediumImpact();
        _bounceController.reset();
        _bounceController.forward();
      },
      child: Column(
        children: [
          // Weather Icon with Animation
          AnimatedBuilder(
            animation: _bounceAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _bounceAnimation.value,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.orange.withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.wb_sunny,
                          size: 80,
                          color: Colors.orange,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          
          const SizedBox(height: 20),
          
          // Temperature
          AnimatedBuilder(
            animation: _bounceAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - _bounceAnimation.value)),
                child: Opacity(
                  opacity: _bounceAnimation.value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "28",
                        style: TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.w200,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          "°C",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w300,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 10),
          
          // Weather Description
          AnimatedBuilder(
            animation: _bounceAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 30 * (1 - _bounceAnimation.value)),
                child: Opacity(
                  opacity: _bounceAnimation.value * 0.9,
                  child: Column(
                    children: [
                      Text(
                        "Sunny",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Feels like 32°C",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 25),
          
          // Min/Max Temperature Row
          AnimatedBuilder(
            animation: _bounceAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 40 * (1 - _bounceAnimation.value)),
                child: Opacity(
                  opacity: _bounceAnimation.value * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTempInfo("Min", "22°", Icons.arrow_downward, Colors.blue),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      _buildTempInfo("Max", "35°", Icons.arrow_upward, Colors.red),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTempInfo(String label, String temp, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: color.withOpacity(0.8),
          size: 20,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          temp,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}