import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_weatherapp/services/weather_service.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    with TickerProviderStateMixin {
  int index = 0;

  final String _apiKey = '182830387e337cc381da6ab54aa2300c';
  late final WeatherService _weatherService = WeatherService(_apiKey);
  Weather? _weather;
  bool _isRefreshing = false;
  DateTime? _lastUpdateTime;

  @override
  void initState() {
    super.initState();
    GoogleFonts.config.allowRuntimeFetching = true;
    GoogleFonts.poppins(
      fontWeight: FontWeight.w400,
      textStyle: const TextStyle(fontSize: 0),
    );
    GoogleFonts.poppins(
      fontWeight: FontWeight.w600,
      textStyle: const TextStyle(fontSize: 0),
    );
    GoogleFonts.poppins(
      fontWeight: FontWeight.w700,
      textStyle: const TextStyle(fontSize: 0),
    );
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _isRefreshing = true;
    });

    final startTime = DateTime.now();
    const minimumLoadingTime = Duration(seconds: 3);

    try {
      String cityName = await _weatherService.getCurrentCity();
      final weather = await _weatherService.getWeather(cityName);

      final elapsedTime = DateTime.now().difference(startTime);
      final remainingTime = minimumLoadingTime - elapsedTime;
      if (remainingTime.inMilliseconds > 0) {
        await Future.delayed(remainingTime);
      }

      setState(() {
        _weather = weather;
        _lastUpdateTime = DateTime.now();
        _isRefreshing = false;
      });
    } catch (e) {
      print(e);
      final elapsedTime = DateTime.now().difference(startTime);
      final remainingTime = minimumLoadingTime - elapsedTime;
      if (remainingTime.inMilliseconds > 0) {
        await Future.delayed(remainingTime);
      }
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  String getWeatherCondition(String? mainCondition) {
    switch (mainCondition?.toLowerCase()) {
      case 'clear':
        return 'assets/sunny.json';
      case 'clouds':
      case 'overcast clouds':
        return 'assets/cloudy.json';
      case 'rain':
        return 'assets/rain.json';
      case 'snow':
        return 'assets/snow.json';
      case 'thunderstorm':
        return 'assets/thunderstorm.json';
      case 'haze':
      case 'mist':
        return 'assets/haze.json';
      default:
        return 'assets/sunny.json';
    }
  }

  List<Color> getBackgroundGradient(String? mainCondition) {
    switch (mainCondition?.toLowerCase()) {
      case 'clear':
        return [Colors.orange.shade600, Colors.yellow.shade300];
      case 'clouds':
        return [Colors.grey.shade600, Colors.blueGrey.shade200];
      case 'rain':
      case 'drizzle':
        return [Colors.blue.shade800, Colors.blue.shade300];
      case 'snow':
        return [Colors.white, Colors.blue.shade100];
      case 'thunderstorm':
        return [Colors.purple.shade800, Colors.grey.shade400];
      default:
        return [Colors.blue.shade800, Colors.blue.shade300];
    }
  }

  String capitalizeWords(String? input) {
    if (input == null || input.isEmpty) return 'Unknown';
    return input
        .split(' ')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
              : '',
        )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final weatherAnimation = getWeatherCondition(_weather?.mainCondition);
    final gradientColors = getBackgroundGradient(_weather?.mainCondition);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: _weather == null
              ? const Center(
                  child: SpinKitFoldingCube(color: Colors.white, size: 50.0),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                _weather!.cityName,
                                style: GoogleFonts.poppins(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Lottie.asset(
                        weatherAnimation,
                        width: 250,
                        height: 250,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '${_weather!.temperature.round()}°C',
                        style: GoogleFonts.poppins(
                          fontSize: 48,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        capitalizeWords(_weather!.mainCondition),
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Humidity: ${_weather!.humidity}%',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Feels Like: ${_weather!.feelsLike.round()}°C',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        'Wind Speed: ${(_weather!.windSpeed * 3.6).toStringAsFixed(1)} kmph',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 20),
                      IconButton(
                        onPressed: _isRefreshing ? null : _fetchWeather,
                        icon: AnimatedRotation(
                          turns: _isRefreshing ? 1 : 0,
                          duration: const Duration(seconds: 1),
                          child: Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        tooltip: 'Refresh Weather',
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _lastUpdateTime != null
                            ? 'Last updated: ${_lastUpdateTime!.hour % 12 == 0 ? 12 : _lastUpdateTime!.hour % 12}:${_lastUpdateTime!.minute.toString().padLeft(2, '0')} ${_lastUpdateTime!.hour >= 12 ? 'PM' : 'AM'}'
                            : 'Updating...',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
