import 'package:bloc_weather2/features/weather/model/weather_model.dart';
import 'package:bloc_weather2/features/weather/service/WeatherService.dart';
import 'package:bloc_weather2/features/weather/viewmodel/IWeather_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

class WeatherCubit extends Cubit<WeatherState> implements IWeatherViewModel {
  WeatherCubit({required this.weatherService}) : super(WeatherInitial());

  final WeatherService weatherService;
  bool isLoading = false;

  @override
  Future<void> fetchWeatherData({String? city}) async {
    changeLoadingStatus();
    final data = await weatherService.fetchWeather(city: city);
    changeLoadingStatus();
    if (data != null) {
      emit(WeatherComplete(weather: data));
    } else {
      emit(WeatherError(error: "Aranılan Şehir Bulunamadı!"));
    }
  }

  void changeLoadingStatus() {
    isLoading = !isLoading;
    emit(WeatherLoading(isLoading));
  }
}

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherComplete extends WeatherState {
  WeatherComplete({required this.weather});
  Weather? weather;
}

class WeatherError extends WeatherState {
  WeatherError({required this.error});
  String? error;
}

class WeatherLoading extends WeatherState {
  WeatherLoading(this.isLoading);
  bool isLoading = false;
}
