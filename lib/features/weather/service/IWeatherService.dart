import 'package:bloc_weather2/features/weather/model/weather_model.dart';

abstract class IWeatherService {
  Future<Weather?> fetchWeather({String? city});
}
