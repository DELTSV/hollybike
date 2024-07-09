import 'package:flutter/material.dart';
import 'package:hollybike/shared/utils/add_separators.dart';
import 'package:hollybike/shared/utils/dates.dart';
import 'package:hollybike/weather/types/weather_forecast_grouped.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../types/weather_condition.dart';

class WeatherForecastModal extends StatelessWidget {
  final WeatherForecastGrouped weatherForecast;

  const WeatherForecastModal({
    super.key,
    required this.weatherForecast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(31),
          topRight: Radius.circular(31),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Prévisions météo',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 400,
                ),
                child: _buildWeatherForecast(context),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherForecast(BuildContext context) {
    final groups = weatherForecast.dailyWeather.map((dailyWeather) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildDayHeader(dailyWeather),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: Column(
                children: addSeparators(
                  dailyWeather.hourlyWeather.map((hourlyWeather) {
                    return _buildHourlyData(hourlyWeather);
                  }).toList(),
                  Divider(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.5),
                    height: 0.5,
                    thickness: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();

    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        return groups[index];
      },
    );
  }

  Widget _buildDayHeader(DailyWeatherGrouped dailyWeather) {
    final date = dailyWeather.date;

    DateTime dateTime = DateTime.parse(date);
    String dayName = DateFormat('EEEE d', 'fr_FR').format(dateTime);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '${dayName.capitalize()} ',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const TextSpan(
            text: '- ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal, // Make dash not bold
            ),
          ),
          TextSpan(
            text:
                '${dailyWeather.maxTemperature} / ${dailyWeather.minTemperature}',
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyData(HourlyWeather hourlyWeather) {
    String hourString = hourlyWeather.time;
    String temperature = hourlyWeather.temperature;
    String weatherCondition =
        getWeatherConditionLabel(hourlyWeather.weatherCondition);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Lottie.asset(
            getWeatherConditionLottiePath(
              hourlyWeather.weatherCondition,
              hourlyWeather.isDay,
            ),
            height: 30,
            animate: false,
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: Text(
              hourString,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              temperature,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Text(
            '-  $weatherCondition',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
