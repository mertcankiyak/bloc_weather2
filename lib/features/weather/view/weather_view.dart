import 'package:bloc_weather2/features/weather/service/WeatherService.dart';
import 'package:bloc_weather2/features/weather/viewmodel/weather_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherView extends StatelessWidget with FormValitadion {
  WeatherView({Key? key}) : super(key: key);

  final _weatherService = WeatherService();
  TextEditingController _searchTextController = TextEditingController();
  GlobalKey<FormState> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => WeatherCubit(weatherService: _weatherService),
        child: BlocConsumer<WeatherCubit, WeatherState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: _builAppBar(),
              body: _builMainContainer(context, state),
            );
          },
        ));
  }

  AppBar _builAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.redAccent,
      title: Text("Weather Bloc"),
    );
  }

  Container _builMainContainer(BuildContext context, WeatherState state) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildForm(context),
            if (state is WeatherComplete) ...[
              _weatherItemCard(state)
            ] else if (state is WeatherLoading) ...[
              _circularProgressWidget(state)
            ] else if (state is WeatherError) ...[
              _buildErrorText(state),
            ],
          ],
        ),
      ),
    );
  }

  Form _buildForm(BuildContext context) {
    return Form(
      key: _globalKey,
      child: _buildSearchTextField(context),
    );
  }

  TextFormField _buildSearchTextField(BuildContext context) {
    return TextFormField(
      controller: _searchTextController,
      validator: formValidator,
      decoration: _searchTextFormFieldDecoration(context),
    );
  }

  InputDecoration _searchTextFormFieldDecoration(BuildContext context) {
    return InputDecoration(
      suffixIcon: GestureDetector(
        onTap: () {
          if (_globalKey.currentState!.validate()) {
            context
                .read<WeatherCubit>()
                .fetchWeatherData(city: _searchTextController.text);
          }
        },
        child: Icon(Icons.search),
      ),
      border: OutlineInputBorder(),
      hintText: "Şehir yazınız",
    );
  }

  Text _buildErrorText(WeatherError state) =>
      Text(state.error ?? "Servis Hatası");

  Card _weatherItemCard(WeatherComplete state) {
    return Card(
      child: ListTile(
        title: Text((state.weather?.location?.country) ?? "-"),
        subtitle: Text(state.weather?.location?.name ?? "-"),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(state.weather?.current?.tempC.toString() ?? "-"),
            Text(" \u2103"),
          ],
        ),
        trailing: Text(state.weather?.location?.localtime ?? "-"),
      ),
    );
  }

  Visibility _circularProgressWidget(WeatherLoading state) {
    return Visibility(
      visible: state.isLoading,
      child: Center(
          child: CircularProgressIndicator(
        backgroundColor: Colors.amber,
        color: Colors.grey.shade400,
      )),
    );
  }
}

mixin FormValitadion {
  String? formValidator(String? value) {
    if (value!.isNotEmpty) {
      return null;
    } else {
      return "Bir şehir ismi yazmalısınız";
    }
  }
}
