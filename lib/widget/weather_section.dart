import 'package:flutter/material.dart';
import 'weather_carousel.dart';
import 'dart:ui';

class WeatherExpandableSection extends StatefulWidget {
  const WeatherExpandableSection({super.key});

  @override
  State<WeatherExpandableSection> createState() =>
      _WeatherExpandableSectionState();
}

class _WeatherExpandableSectionState extends State<WeatherExpandableSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isExpanded = false;
  double _height = 250;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      _height = _isExpanded ? 500 : 250; 
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpansion, 
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
        child: SingleChildScrollView(
          child: Column(
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
                height: _isExpanded ? 300 : 150, 
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
              if (_isExpanded) ...[
                const SizedBox(height: 16),
                const Text(
                  "More Details",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "This section can now be expanded to show more details and is scrollable. Tap to collapse.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}