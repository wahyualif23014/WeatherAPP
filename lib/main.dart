import 'package:flutter/material.dart';
import 'package:wheatherapp/screens/home_screen.dart';
import 'package:wheatherapp/screens/mainMenu_screen.dart';
import 'package:wheatherapp/screens/forecast_screen.dart';
import 'package:wheatherapp/screens/map_screen.dart';
import 'package:wheatherapp/screens/favorits.dart';
import 'package:wheatherapp/screens/settings.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  print("✅ .env berhasil dimuat!");
  print("OpenWeather API Key: ${dotenv.env['OPEN_WEATHER_API_KEY']}");
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
        '/map': (context) => MapPage(initialLat: -6.2, initialLng: 106.8, openWeatherKey: dotenv.env['OPEN_WEATHER_API_KEY']!),
        '/favorits': (context) => Favorite(),
        '/settings': (context) => SettingsScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
