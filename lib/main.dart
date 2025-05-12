import 'package:flutter/material.dart';
import 'package:wheatherapp/screens/home_screen.dart';
import 'package:wheatherapp/screens/mainMenu_screen.dart';
import 'package:wheatherapp/screens/forecast_screen.dart';
import 'package:wheatherapp/screens/map_screen.dart';
// import 'package:wheatherapp/screens/favorites_screen.dart';
// import 'package:wheatherapp/screens/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData.dark(),
      initialRoute: '/mainmenu',
      routes: {
        '/': (context) => HomeScreen(),
        '/mainmenu': (context) => MainMenuScreen(),
        '/home': (context) => HomeScreen(),
        '/forecast': (context) => ForecastScreen(),
        '/map': (context) => MapScreen(),
        // '/favorites': (context) => FavoritesScreen(),
        // '/settings': (context) => SettingsScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
