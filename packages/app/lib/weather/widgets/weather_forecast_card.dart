/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/shared/types/position.dart';
import 'package:hollybike/weather/widgets/weather_forecast_card_content.dart';
import 'package:hollybike/weather/widgets/weather_forecast_empty_card.dart';

class WeatherForecastCard extends StatelessWidget {
  final EventDetails eventDetails;

  const WeatherForecastCard({super.key, required this.eventDetails});

  @override
  Widget build(BuildContext context) {
    final destination = eventDetails.journey?.destination;

    if (destination == null) {
      return const SizedBox();
    }

    return Column(
      children: [
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: _buildWeatherForecastCardContent(context, destination),
        )
      ],
    );
  }

  Widget _buildWeatherForecastCardContent(
    BuildContext context,
    Position destination,
  ) {
    final startDate = eventDetails.event.startDate;

    final endDate = eventDetails.event.endDate ?? startDate.add(const Duration(hours: 4));

    if (endDate.isBefore(DateTime.now())) {
      return const WeatherForecastEmptyCard(
        message:
            'La météo est disponible uniquement pour les événements à venir.',
      );
    }

    if (startDate.difference(DateTime.now()).inDays > 5) {
      return const WeatherForecastEmptyCard(
        message:
            'La météo est disponible uniquement pour les 5 prochains jours.',
      );
    }

    return WeatherForecastCardContent(
      destination: destination,
      startDate: startDate,
      endDate: eventDetails.event.endDate,
    );
  }
}
