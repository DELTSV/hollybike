import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/journey/widgets/journey_position.dart';
import 'package:hollybike/shared/types/position.dart';
import 'package:hollybike/weather/types/weather_condition.dart';
import 'package:hollybike/weather/types/weather_forecast_grouped.dart';
import 'package:hollybike/weather/widgets/weather_forecast_empty_card.dart';
import 'package:hollybike/weather/widgets/weather_forecast_modal.dart';
import 'package:lottie/lottie.dart';

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
              height: 120,
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
              height: 120,
              width: double.infinity,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: state is WeatherForecastSuccess
                      ? () => onTap(context, state.weatherForecast)
                      : null,
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
            crossFadeState: (state is WeatherForecastLoading ||
                    state is WeatherForecastInitial)
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 300),
          );
        },
      ),
    );
  }

  void onTap(BuildContext context, WeatherForecastGrouped weatherForecast) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return WeatherForecastModal(
            weatherForecast: weatherForecast,
          );
        });
  }

  Widget _buildForecast(BuildContext context, WeatherForecastState state) {
    if (state is WeatherForecastSuccess) {
      final weatherForecast = state.weatherForecast;

      final firstDay = weatherForecast.dailyWeather.first;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                top: 16,
                bottom: 16,
                right: 0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  JourneyPosition(
                    pos: destination,
                    isLarge: true,
                  ),
                  Text(
                    '${firstDay.maxTemperature} / ${firstDay.minTemperature} - ${getWeatherConditionLabel(firstDay.weatherCondition)}',
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Lottie.asset(
            getWeatherConditionLottiePath(
              firstDay.weatherCondition,
              firstDay.hourlyWeather.first.isDay,
            ),
          ),
        ],
      );
    }

    return const WeatherForecastEmptyCard(
      message: 'Donnés météo non disponibles.',
    );
  }
}
