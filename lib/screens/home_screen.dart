import 'package:flutter/material.dart';
// import '../widget/weather_carousel.dart';
import '../widget/location_display.dart';
import '../widget/bottom_navbar.dart';
import '../widget/weather_section.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final String backgroundImageUrl =
      'https://images.unsplash.com/photo-1745521245831-422f7f9140ac?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDN8Ym84alFLVGFFMFl8fGVufDB8fHx8fA%3D%3D'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Column(
              children: [
                SizedBox(height: 50),                
                LocationDisplay(),
                SizedBox(height: 50),
                WeatherSection(),
                // Expanded(child: WeatherCarousel()),
              ],
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
    );
  }
}
