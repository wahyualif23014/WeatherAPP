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
    _dragOffset += details.primaryDelta!; // Track the drag offset
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
      pageBuilder:
          (context, animation, secondaryAnimation) =>
              WeatherDetailExpandedScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              // Create slide animation
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
              child: Image.network(backgroundImageUrl, fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: Container(color: Color(0xFF2E2961).withOpacity(0.6)),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    LocationDisplay(),
                    SizedBox(height: 50),
                    WeatherExpandableSection(), // Now only display the weather section
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
          // Blur Background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1745521245831-422f7f9140ac?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDN8Ym84alFLVGFFMFl8fGVufDB8fHx8fA%3D%3D',
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3),
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
          ),

          // Weather Detail Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 36,
                    color: Colors.white70,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Jakarta, Indonesia",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Mostly Cloudy",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "27°C",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(color: Colors.white24),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _weatherDetailItem(Icons.water_drop, "Humidity", "78%"),
                      _weatherDetailItem(Icons.air, "Wind", "12 km/h"),
                      _weatherDetailItem(Icons.thermostat, "Feels Like", "26°C"),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Divider(color: Colors.white24),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _weatherDetailItem(Icons.wb_sunny, "UV Index", "Low"),
                      _weatherDetailItem(Icons.visibility, "Visibility", "8 km"),
                      _weatherDetailItem(Icons.compress, "Pressure", "1012 hPa"),
                    ],
                  ),
                  Spacer(),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_downward),
                    label: Text("Swipe down to return"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.15),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Modular weather detail widget
  Widget _weatherDetailItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}