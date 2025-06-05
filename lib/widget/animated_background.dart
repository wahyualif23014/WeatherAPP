// widgets/animated_background.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedBackground extends StatefulWidget {
  final double opacity;
  
  const AnimatedBackground({Key? key, required this.opacity}) : super(key: key);

  @override
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _cloudController;
  late AnimationController _gradientController;
  
  final String backgroundImageUrl =
      'https://images.unsplash.com/photo-1745521245831-422f7f9140ac?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDN8Ym84alFLVGFFMFl8fGVufDB8fHx8fA%3D%3D';

  @override
  void initState() {
    super.initState();
    _cloudController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _gradientController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cloudController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.network(
            backgroundImageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1E3C72),
                      Color(0xFF2A5298),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        
        // Animated Overlay
        AnimatedBuilder(
          animation: _gradientController,
          builder: (context, child) {
            return Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2E2961).withOpacity(widget.opacity),
                      Color(0xFF1A1A2E).withOpacity(widget.opacity * 0.8),
                      Color(0xFF16213E).withOpacity(widget.opacity * 0.9),
                    ],
                    stops: [
                      0.0,
                      0.5 + (_gradientController.value * 0.3),
                      1.0,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        
        // Floating Particles
        ...List.generate(15, (index) => _buildFloatingParticle(index)),
      ],
    );
  }

  Widget _buildFloatingParticle(int index) {
    return AnimatedBuilder(
      animation: _cloudController,
      builder: (context, child) {
        final progress = (_cloudController.value + index * 0.1) % 1.0;
        final size = MediaQuery.of(context).size;
        
        return Positioned(
          left: -50 + (size.width + 100) * progress,
          top: 50 + (index * 40) + math.sin(progress * 2 * math.pi) * 20,
          child: Opacity(
            opacity: 0.1 + (math.sin(progress * math.pi) * 0.1),
            child: Container(
              width: 4 + (index % 3) * 2,
              height: 4 + (index % 3) * 2,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}