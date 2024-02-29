// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../models/weather_model.dart';
import '../services/weather_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _weatherService =
      WeatherService(apiKey: 'b55608bf7436ba84f880888d579c86f9');
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);

      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/images/sunny.json';
    }
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/images/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/images/son_rain.json';
      case 'thunderstorm':
        return 'assets/images/rain.json';
      case 'clear':
        return 'assets/images/sunny.json';
      default:
        return 'assets/images/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(115, 35, 35, 35),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // city name
            const Icon(
              CupertinoIcons.location_solid,
              color: Colors.grey,
            ),

            Text(
              _weather?.cityName ?? 'City..',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 100),

            //animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            const SizedBox(height: 100),

            // tempreature
            Text(
              '${_weather?.temperature.round()}°',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 70,
                fontWeight: FontWeight.bold,
              ),
            ),

            // weather conditdion
          ],
        ),
      ),
    );
  }
}
