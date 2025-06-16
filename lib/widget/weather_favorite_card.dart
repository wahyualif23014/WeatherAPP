import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui';

class WeatherFavoriteCard extends StatefulWidget {
  final String city;
  final int temperature;
  final String condition;
  final IconData icon;

  const WeatherFavoriteCard({
    super.key,
    required this.city,
    required this.temperature,
    required this.condition,
    required this.icon,
  });

  @override
  State<WeatherFavoriteCard> createState() => _WeatherFavoriteCardState();
}

class _WeatherFavoriteCardState extends State<WeatherFavoriteCard>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _controller;

  void toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    toggleExpand();
  }

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final value = Curves.easeInOut.transform(_controller.value);
          final scaleFactor = 1 - (0.05 * value);

          return Transform.scale(
            scale: scaleFactor,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 10,
                        offset: Offset(0, 6),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Lottie.network(
                              'https://lottie.host/026e82a4-5a6d-4fc3-9b4f-9af888676935/kAbseRoblD.json', 
                              fit: BoxFit.contain,
                              frameBuilder: (context, child, composition) {
                                if (composition == null) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                return child;
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error_outline, color: Colors.red),
                            ),
                          ),

                          const SizedBox(width: 16),
                          Text(
                            widget.city,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${widget.temperature}°C',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      if (isExpanded) ...[
                        const SizedBox(height: 10),
                        Text(
                          'Condition: ${widget.condition}',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Swipe down for more details.',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}