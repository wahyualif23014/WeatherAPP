// forecast_screen.dart
import 'package:flutter/material.dart';
import '../widget/weekly_forecast_list.dart';
import '../widget/MonthlyForecastList.dart';



class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Prakiraan Mingguan"),
        backgroundColor: Colors.deepPurple[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Cuaca Minggu Ini",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const WeeklyForecastList(),
            const SizedBox(height: 24),
            const Text(
              "Detail & Analisa Cuaca",
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Text(
              "Analisa tren suhu dan kelembaban akan ditampilkan di sini...",
              style: TextStyle(fontSize: 16, color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            const MonthlyForecastList(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
