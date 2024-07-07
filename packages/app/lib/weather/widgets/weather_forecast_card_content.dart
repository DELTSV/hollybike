import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/shared/types/position.dart';
import 'package:hollybike/weather/widgets/weather_forecast_empty_card.dart';

import '../bloc/weather_forecast_bloc.dart';
import '../bloc/weather_forecast_event.dart';
import '../bloc/weather_forecast_state.dart';
import '../services/weather_forecast_api.dart';

class WeatherForecastCardContent extends StatelessWidget {
  final Position destination;
  final DateTime startDate;
  final DateTime? endDate;

  const WeatherForecastCardContent({
    super.key,
    required this.destination,
    required this.startDate,
    this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherForecastBloc(
        weatherForecastApi: WeatherForecastApi(),
      )..add(FetchWeatherForecast(
          latitude: destination.latitude,
          longitude: destination.longitude,
          startDate: startDate,
          endDate: endDate,
        )),
      child: BlocBuilder<WeatherForecastBloc, WeatherForecastState>(
        builder: (context, state) {
          return AnimatedCrossFade(
            firstChild: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              width: double.infinity,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            secondChild: SizedBox(
              height: 100,
              width: double.infinity,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(14),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: _buildForecast(context, state),
                  ),
                ),
              ),
            ),
            crossFadeState: (state is WeatherForecastLoading || state is WeatherForecastInitial)
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 300),
          );
        },
      ),
    );
  }

  Widget _buildForecast(BuildContext context, WeatherForecastState state) {
    if (state is WeatherForecastSuccess) {
      return Column(
        children: state.weatherForecast.dailyWeather.map((dailyWeather) {
          return Text(dailyWeather.maxTemperature);
        }).toList(),
      );
    }

    return const WeatherForecastEmptyCard(
      message: 'Donnés météo non disponibles.',
    );
  }
}
