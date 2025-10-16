import 'package:flutter/material.dart';
import 'package:wheatherapp/widget/MonthlyForecastList.dart';
import '../widget/weekly_forecast_list.dart';
import '../widget/glassmorphic_card.dart';
import 'dart:ui';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final urlBackground = "https://images.unsplash.com/photo-1503428642-07ba9c4b3f7d?auto=format&fit=crop&w=1470&q=80";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Weekly Forecast"),
        backgroundColor: Colors.deepPurple[900],
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          _buildBackground(urlBackground),

          // Overlay Dark Gradient (Agar teks terlihat)
          _buildOverlayGradient(),

          // Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GlassmorphicCard(
                  blurStrength: 15,
                  borderRadius: 16,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        const Text(
                          "This Week's Weather",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const WeeklyForecastList(),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                GlassmorphicCard(
                  blurStrength: 10,
                  borderRadius: 16,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.15),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Detail & Analysis",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Analysis of temperature and humidity trends will be displayed here...",
                          style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const MonthlyForecastList(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(String imageUrl) {
    return ShaderMask(
      shaderCallback: (rect) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Colors.transparent],
        ).createShader(rect);
      },
      blendMode: BlendMode.darken,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.error_outline, color: Colors.red));
        },
      ),
    );
  }

  Widget _buildOverlayGradient() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.95),
          ],
          stops: const [0.0, 0.6],
        ),
      ),
    );
  }
}