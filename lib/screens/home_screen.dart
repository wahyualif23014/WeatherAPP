// home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../widget/animated_background.dart';
import '../widget/glassmorphic_card.dart';
import '../widget/weather_hero_section.dart';
import '../widget/weather_metrics_grid.dart';
import '../widget/hourly_forecast_section.dart';
import '../widget/daily_forecast_section.dart';
import '../widget/air_quality_section.dart';
import '../widget/sunrise_sunset_section.dart';
// import '../widget/location_display.dart';
import '../widget/bottom_navbar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late ScrollController _scrollController;
  
  double _backgroundOpacity = 0.7;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scrollController = ScrollController();
    
    _fadeController.forward();
    _slideController.forward();
    
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    setState(() {
      _backgroundOpacity = (0.7 + (offset / 300).clamp(0.0, 0.3));
      _isScrolled = offset > 50;
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAnimatedAppBar(),
      body: Stack(
        children: [
          // Animated Background
          AnimatedBackground(opacity: _backgroundOpacity),
          
          // Main Content
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              backgroundColor: Colors.white.withOpacity(0.1),
              color: Colors.white,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: FadeTransition(
                      opacity: _fadeController,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _slideController,
                          curve: Curves.easeOutCubic,
                        )),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              
                              // Location Display
                              // AnimatedLocationDisplay(),
                              
                              const SizedBox(height: 30),
                              
                              // Weather Hero Section
                              WeatherHeroSection(),
                              
                              const SizedBox(height: 25),
                              
                              // Weather Metrics Grid
                              WeatherMetricsGrid(),
                              
                              const SizedBox(height: 25),
                              
                              // Hourly Forecast
                              HourlyForecastSection(),
                              
                              const SizedBox(height: 25),
                              
                              // Air Quality Section
                              AirQualitySection(),
                              
                              const SizedBox(height: 25),
                              
                              // Sunrise/Sunset Section
                              SunriseSunsetSection(),
                              
                              const SizedBox(height: 25),
                              
                              // Daily Forecast
                              DailyForecastSection(),
                              
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          HapticFeedback.lightImpact();
        },
      ),
    );
  }

  PreferredSizeWidget _buildAnimatedAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: _isScrolled
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                  ],
                )
              : null,
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.mediumImpact();
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    // Add your weather data refresh logic here
  }
}