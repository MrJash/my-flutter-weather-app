import 'package:flutter/material.dart';
import 'package:flutter_weatherapp/pages/weather_page.dart'; // Adjust import based on your project structure

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WeatherPage(), // Set WeatherPage as the home screen
    );
  }
}