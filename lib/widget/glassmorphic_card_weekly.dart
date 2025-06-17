// widgets/glassmorphic_card.dart
import 'package:flutter/material.dart';
import 'dart:ui';

class GlassmorphicCardweekly extends StatelessWidget {
  final Widget child;
  final double blur;
  final double borderRadius;
  final double border;
  final Color borderColor;
  final LinearGradient linearGradient;

  const GlassmorphicCardweekly({
    Key? key,
    required this.child,
    this.blur = 10,
    this.borderRadius = 16,
    this.border = 1.2,
    this.borderColor = const Color(0xFFFFFFFF),
    required this.linearGradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor.withOpacity(0.2),
              width: border,
            ),
            gradient: linearGradient,
          ),
          child: child,
        ),
      ),
    );
  }
}