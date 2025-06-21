import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'glassmorphic_card.dart';

class MonthlyForecastList extends StatelessWidget {
  const MonthlyForecastList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> monthlyData = [
      {"month": "Jan", "avgHigh": 31, "avgLow": 24},
      {"month": "Feb", "avgHigh": 32, "avgLow": 25},
      {"month": "Mar", "avgHigh": 33, "avgLow": 26},
      {"month": "Apr", "avgHigh": 34, "avgLow": 27},
      {"month": "Mei", "avgHigh": 32, "avgLow": 26},
      {"month": "Jun", "avgHigh": 31, "avgLow": 25},
      {"month": "Jul", "avgHigh": 30, "avgLow": 24},
      {"month": "Agu", "avgHigh": 30, "avgLow": 23},
      {"month": "Sep", "avgHigh": 31, "avgLow": 24},
      {"month": "Okt", "avgHigh": 32, "avgLow": 25},
      {"month": "Nov", "avgHigh": 33, "avgLow": 26},
      {"month": "Des", "avgHigh": 31, "avgLow": 25},
    ];

    return GlassmorphicCard(
      blurStrength: 15,
      borderRadius: 24,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.15),
          Colors.white.withOpacity(0.05),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Forecast',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 300,
              child: ListView.separated(
                itemCount: monthlyData.length,
                itemBuilder: (context, index) {
                  final data = monthlyData[index];
                  return _buildMonthlyItem(context, data);
                },
                separatorBuilder: (_, __) => const SizedBox(height: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyItem(BuildContext context, Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
      },
      child: GlassmorphicCard(
        blurStrength: 10,
        borderRadius: 12,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data['month'],
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "${data['avgHigh']}° / ${data['avgLow']}°",
                style: const TextStyle(
                  color: Colors.white,
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
} 