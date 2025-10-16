import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wheatherapp/models/weather_model.dart';
import 'package:wheatherapp/service/WeatherService.dart';

class WeatherHeroSection extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String locationName;

  const WeatherHeroSection({
    Key? key,
    required this.latitude,
    required this.longitude,
    this.locationName = '',
  }) : super(key: key);

  @override
  _WeatherHeroSectionState createState() => _WeatherHeroSectionState();
}

class _WeatherHeroSectionState extends State<WeatherHeroSection>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _bounceController;

  late Animation<double> _pulseAnimation;
  late Animation<double> _bounceAnimation;

  final WeatherService _weatherService = WeatherService();
  WeatherModel? _weather;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _fetchWeather();
  }

  void _initAnimations() {
    _pulseController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);

    _bounceController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _bounceController.forward();
  }

  Future<void> _fetchWeather() async {
    try {
      final data = await _weatherService.fetchFromOpenMeteo(
        lat: widget.latitude,
        lon: widget.longitude,
        locationName: widget.locationName,
      );
      setState(() {
        _weather = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.mediumImpact();
    _bounceController
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaleFactor = size.width / 400;

    return GestureDetector(
      onTap: _handleTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final adaptiveScale = constraints.maxWidth / 400;

          if (_isLoading) {
            return _buildLoading(adaptiveScale);
          }

          if (_error != null) {
            return _buildError(adaptiveScale);
          }

          final weather = _weather!;
          return _buildWeatherContent(weather, adaptiveScale);
        },
      ),
    );
  }

  // ---------------- UI SECTION ----------------

  Widget _buildLoading(double scale) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24 * scale),
        child: const CircularProgressIndicator(
          color: Colors.orangeAccent,
        ),
      ),
    );
  }

  Widget _buildError(double scale) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24 * scale),
        child: Text(
          _error ?? "Failed to load weather data",
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 14 * scale,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildWeatherContent(WeatherModel weather, double scale) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20 * scale),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20 * scale),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 25 * scale,
            horizontal: 16 * scale,
          ),
          child: Column(
            children: [
              // 🌤 Icon utama
              ScaleTransition(
                scale: _bounceAnimation,
                child: ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    width: 120 * scale,
                    height: 120 * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.orange.withOpacity(0.4),
                          Colors.transparent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.4),
                          blurRadius: 20 * scale,
                          spreadRadius: 5 * scale,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.wb_sunny,
                      size: 80 * scale,
                      color: Colors.yellowAccent,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20 * scale),

              // 🌡 Suhu
              FadeTransition(
                opacity: _bounceAnimation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.temp.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 72 * scale,
                        fontWeight: FontWeight.w200,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8 * scale),
                      child: Text(
                        "°C",
                        style: TextStyle(
                          fontSize: 24 * scale,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10 * scale),

              // 🌈 Kondisi
              FadeTransition(
                opacity: _bounceAnimation,
                child: Column(
                  children: [
                    Text(
                      weather.condition,
                      style: TextStyle(
                        fontSize: 20 * scale,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5 * scale),
                    Text(
                      "Feels like ${weather.feelsLike.toStringAsFixed(1)}°C",
                      style: TextStyle(
                        fontSize: 14 * scale,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    if (weather.locationName.isNotEmpty) ...[
                      SizedBox(height: 8 * scale),
                      Text(
                        weather.locationName,
                        style: TextStyle(
                          fontSize: 16 * scale,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(height: 25 * scale),

              // 📉 Min / Max
              FadeTransition(
                opacity: _bounceAnimation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTempInfo(
                        "Min",
                        "${weather.minTemp.toStringAsFixed(0)}°",
                        Icons.arrow_downward,
                        Colors.cyan,
                        scale),
                    Container(
                      width: 1 * scale,
                      height: 40 * scale,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    _buildTempInfo(
                        "Max",
                        "${weather.maxTemp.toStringAsFixed(0)}°",
                        Icons.arrow_upward,
                        Colors.orange,
                        scale),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTempInfo(
      String label, String temp, IconData icon, Color color, double scale) {
    return Column(
      children: [
        Icon(icon, color: color.withOpacity(0.8), size: 20 * scale),
        SizedBox(height: 8 * scale),
        Text(
          label,
          style: TextStyle(
            fontSize: 12 * scale,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        SizedBox(height: 4 * scale),
        Text(
          temp,
          style: TextStyle(
            fontSize: 18 * scale,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
