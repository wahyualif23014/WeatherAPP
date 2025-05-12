import 'package:flutter/material.dart';
import 'weather_carousel.dart';
import 'dart:ui';

class WeatherExpandableSection extends StatefulWidget {

  @override
  State<WeatherExpandableSection> createState() =>
      _WeatherExpandableSectionState();
}

class _WeatherExpandableSectionState extends State<WeatherExpandableSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double _dragOffset = 0;
  bool _isExpanded = false;
  double _height = 250;

  final double _dragThreshold = 100; // Minimal jarak drag untuk trigger swipe
  final double _velocityThreshold = -300; // Minimal kecepatan swipe

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    _dragOffset += details.primaryDelta!;
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_dragOffset < -_dragThreshold ||
        (details.primaryVelocity != null &&
            details.primaryVelocity! < _velocityThreshold)) {
      setState(() {
        _isExpanded = true;
        _height = MediaQuery.of(context).size.height;
      });

      Future.delayed(const Duration(milliseconds: 200), () {
        Navigator.of(context).push(_createSmoothTransition()).then((_) {
          // Reset kembali setelah pop
          setState(() {
            _isExpanded = false;
            _height = 250;
            _dragOffset = 0;
          });
        });
      });
    } else {
      // Reset offset jika tidak memenuhi syarat swipe
      _dragOffset = 0;
    }
  }

  Route _createSmoothTransition() {
    return PageRouteBuilder(
      pageBuilder:
          (context, animation, secondaryAnimation) =>
              WeatherDetailExpandedScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: _height,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_isExpanded ? 0 : 30),
          gradient: const LinearGradient(
            colors: [Color(0xFF6C49D9), Color(0xFF8A3FD1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child:
            !_isExpanded
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.white,
                      indicatorWeight: 2,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      tabs: const [
                        Tab(text: "Hourly Forecast"),
                        Tab(text: "Weekly Forecast"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 150,
                      child: TabBarView(
                        controller: _tabController,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          const WeatherCarousel(),
                          const Center(
                            child: Text(
                              "Weekly Forecast Coming Soon...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                : const SizedBox.shrink(),
      ),
    );
  }
}

class WeatherDetailExpandedScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              color: Colors.deepPurple.shade900.withOpacity(0.5),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  const Icon(
                    Icons.cloud_outlined,
                    size: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Cloudy with scattered showers",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Humidity: 78% | Wind: 12 km/h | Feels like: 26°C",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 200),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_downward),
                    label: const Text("Swipe down to return"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
