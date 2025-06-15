import 'package:flutter/material.dart';
import 'dart:ui';

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

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        color: Colors.white.withOpacity(0.05),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'monthly forecast',
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
                return Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    // 💡 Efek blur tambahan untuk item
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        spreadRadius: -3,
                      )
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
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
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 8),
            ),
          ),
        ],
      ),
    );
  }
}