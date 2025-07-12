import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http; // Missing import
import 'dart:convert'; // Missing import for jsonDecode
import 'package:geocoding/geocoding.dart'; // Missing import for placemarkFromCoordinates

class WeatherService {
  static const baseUrl = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }

  Future<String> getCurrentCity() async {
  try {
    // Check and request location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions permanently denied');
    }

    // Use LocationSettings for better location accuracy
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    // Fetch the current location
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    // Convert coordinates to placemark
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // Extract city name from first placemark
    String? city;
    if (placemarks.isNotEmpty) {
      city = placemarks[0].locality;
      // Fallback to administrativeArea or other fields if locality is null or empty
      if (city == null || city.isEmpty) {
        city = placemarks[0].administrativeArea ?? placemarks[0].country;
      }
    }

    return city ?? 'Ahmedabad'; // Default fallback
  } catch (e) {
    // On Windows or error, fallback to default city
    return 'Ahmedabad';
  }
}
}

// Define Weather class (was missing)
class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final int humidity; // Percentage
  final double feelsLike; // Celsius
  final double windSpeed;

  Weather({
    required this.cityName, 
    required this.temperature, 
    required this.mainCondition,
    required this.humidity,
    required this.feelsLike,
    required this.windSpeed,
 });

factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      humidity: json['main']['humidity'],
      feelsLike: json['main']['feels_like'].toDouble(),
      windSpeed: json['wind']['speed'].toDouble(),
    );
  }
}