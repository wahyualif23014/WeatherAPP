// widgets/glassmorphic_card.dart
import 'package:flutter/material.dart';
import 'dart:ui';

class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blurStrength;
  final double opacity;
  final VoidCallback? onTap;
  final bool enableBorder;

  const GlassmorphicCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.borderRadius = 20,
    this.blurStrength = 10,
    this.opacity = 0.15,
    this.onTap,
    this.enableBorder = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurStrength, sigmaY: blurStrength),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(opacity),
                borderRadius: BorderRadius.circular(borderRadius),
                border: enableBorder
                    ? Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedGlassmorphicCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;
  final Duration animationDuration;

  const AnimatedGlassmorphicCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.borderRadius = 20,
    this.onTap,
    this.animationDuration = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  _AnimatedGlassmorphicCardState createState() => _AnimatedGlassmorphicCardState();
}

class _AnimatedGlassmorphicCardState extends State<AnimatedGlassmorphicCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 0.15,
      end: 0.25,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        if (widget.onTap != null) {
          Future.delayed(const Duration(milliseconds: 100), widget.onTap);
        }
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GlassmorphicCard(
              width: widget.width,
              height: widget.height,
              padding: widget.padding,
              margin: widget.margin,
              borderRadius: widget.borderRadius,
              opacity: _opacityAnimation.value,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}