import 'package:bloc_weather2/features/weather/model/weather_model.dart';
import 'package:bloc_weather2/features/weather/service/IWeatherService.dart';
import 'package:bloc_weather2/product/constants/AppConstants.dart';
import 'package:bloc_weather2/product/enum/ServiceEnum.dart';
import 'package:bloc_weather2/product/extensions/ServiceExtensions.dart';
import 'package:flutter/material.dart';
import 'package:vexana/vexana.dart';

class WeatherService extends IWeatherService {
  final NetworkManager _networkManager = NetworkManager(
      options: BaseOptions(baseUrl: "https://api.weatherapi.com"));

  @override
  Future<Weather?> fetchWeather({String? city}) async {
    try {
      final response = await _networkManager.send<Weather, Weather>(
          ServicePath.CURRENT.rawValue + apiKey + "&q=" + city!,
          parseModel: Weather(),
          method: RequestType.GET);
      return response.data;
    } catch (e) {
      //Error
    }
  }
}
