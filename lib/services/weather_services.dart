// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const baseUrl = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService({required this.apiKey});

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.formJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placeMarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      String? city = placeMarks.isNotEmpty ? placeMarks[0].locality : null;

      return city ?? 'Unknown City';
    } catch (e) {
      print('Error getting current city: $e');
      return 'Unknown City';
    }
  }
}
