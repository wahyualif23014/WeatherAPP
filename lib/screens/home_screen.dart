import 'package:flutter/material.dart';
import 'dart:ui'; // For ImageFilter
import '../widget/location_display.dart';
import '../widget/bottom_navbar.dart';
import '../widget/weather_section.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  double _dragOffset = 0;
  final double _dragThreshold = 100;
  final double _velocityThreshold = -300;

  final String backgroundImageUrl =
      'https://images.unsplash.com/photo-1745521245831-422f7f9140ac?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDN8Ym84alFLVGFFMFl8fGVufDB8fHx8fA%3D%3D';

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    _dragOffset += details.primaryDelta!;
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_dragOffset < -_dragThreshold ||
        (details.primaryVelocity != null &&
            details.primaryVelocity! < _velocityThreshold)) {
      Navigator.of(context).push(_createSmoothTransition());
    }
    _dragOffset = 0;
  }

  Route _createSmoothTransition() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
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
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                backgroundImageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                color: Color(0xFF2E2961).withOpacity(0.6),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    LocationDisplay(),
                    SizedBox(height: 50),
                    WeatherExpandableSection(), // Sekarang hanya tampilan
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
          },
        ),
      ),
    );
  }
}

class WeatherDetailExpandedScreen extends StatelessWidget {
  const WeatherDetailExpandedScreen({super.key});

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
