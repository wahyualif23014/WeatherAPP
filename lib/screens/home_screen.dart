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
import '../widget/bottom_navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late ScrollController _scrollController;
  
  double _backgroundOpacity = 0.7;
  bool _isScrolled = false;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _startAnimations();
  }

  void _initializeControllers() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scrollController = ScrollController();
    
    // Add scroll listener with null check
    _scrollController.addListener(_onScroll);
  }

  void _startAnimations() {
    // Add delay for better performance
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fadeController.forward();
        _slideController.forward();
      }
    });
  }

  void _onScroll() {
    if (!mounted) return;
    
    final offset = _scrollController.offset;
    final newOpacity = (0.7 + (offset / 300).clamp(0.0, 0.3));
    final newScrollState = offset > 50;
    
    // Only update if there's a meaningful change to reduce rebuilds
    if ((_backgroundOpacity - newOpacity).abs() > 0.01 || 
        _isScrolled != newScrollState) {
      setState(() {
        _backgroundOpacity = newOpacity;
        _isScrolled = newScrollState;
      });
    }
  }

  @override
  void dispose() {
    // Remove listener before disposing
    _scrollController.removeListener(_onScroll);
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
          _buildBackground(),
          
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              backgroundColor: Colors.white.withOpacity(0.1),
              color: Colors.white,
              displacement: 40,
              strokeWidth: 2.5,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildMainContent(),
                  ),
                ],
              ),
            ),
          ),
          
          if (_isRefreshing) _buildLoadingOverlay(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _fadeController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeController.value,
          child: AnimatedBackground(opacity: _backgroundOpacity),
        );
      },
    );
  }

  Widget _buildMainContent() {
    return FadeTransition(
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
              
              _buildSection(() => WeatherHeroSection()),
              
              const SizedBox(height: 25),
              
              _buildSection(() => WeatherMetricsGrid()),
              
              const SizedBox(height: 25),
              
              _buildSection(() => HourlyForecastSection()),
              
              const SizedBox(height: 25),
              
              _buildSection(() => AirQualitySection()),
              
              const SizedBox(height: 25),
              
              _buildSection(() => SunriseSunsetSection()),
              
              const SizedBox(height: 25),
              
              _buildSection(() => DailyForecastSection()),
              
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(Widget Function() builder) {
    try {
      return builder();
    } catch (e) {
      // Error handling for individual sections
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red.withOpacity(0.7),
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                'Section Error',
                style: TextStyle(
                  color: Colors.red.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Memperbarui Data...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    try {
      return CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (mounted && index != _currentIndex) {
            setState(() => _currentIndex = index);
            HapticFeedback.lightImpact();
          }
        },
      );
    } catch (e) {
      // Fallback bottom navigation
      return Container(
        height: 80,
        color: Colors.black.withOpacity(0.8),
        child: const Center(
          child: Text(
            'Navigation Error',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  PreferredSizeWidget _buildAnimatedAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
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
    if (_isRefreshing) return; // Prevent multiple refresh
    
    setState(() => _isRefreshing = true);
    
    try {
      HapticFeedback.mediumImpact();
      
      // Simulate data refresh
      await Future.delayed(const Duration(seconds: 2));
      
      // Here you would typically call your data refresh methods
      // await weatherService.refreshWeatherData();
      
    } catch (e) {
      // Handle refresh error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui data: ${e.toString()}'),
            backgroundColor: Colors.red.withOpacity(0.8),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }
}