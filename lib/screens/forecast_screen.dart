// forecast_screen.dart
import 'package:flutter/material.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prakiraan Mingguan")),
      body: const Center(child: Text("Konten prakiraan cuaca")),
    );
  }
}
