import 'dart:async';

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/widgets/details/status/event_details_status.dart';
import 'package:hollybike/shared/widgets/app_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../shared/utils/dates.dart';
import '../../../types/event_status_state.dart';

class EventScheduledStatus extends StatelessWidget {
  final EventDetails eventDetails;
  final DeviceCalendarPlugin deviceCalendarPlugin = DeviceCalendarPlugin();

  EventScheduledStatus({
    super.key,
    required this.eventDetails,
  });

  @override
  Widget build(BuildContext context) {
    return EventDetailsStatus(
      status: EventStatusState.scheduled,
      message: fromDateToDuration(eventDetails.event.startDate),
      actionText: 'Ajouter au calendrier',
      onAction: () {
        _onAddToCalendar(context);
      },
    );
  }

  Future<Calendar?> getCurrentCalendar() async {
    try {
      final calendars = (await deviceCalendarPlugin.retrieveCalendars()).data;
      return calendars?.firstWhere(
        (calendar) => calendar.name == 'HollyBike',
      );
    } catch (e) {
      return null;
    }
  }

  Future<String?> getEventCalendarId(
    SharedPreferences prefs,
    List<String> events,
  ) async {
    try {
      return events
          .firstWhere(
            (event) => event.split(':')[0] == eventDetails.event.id.toString(),
          )
          .split(':')[1];
    } catch (e) {
      return null;
    }
  }

  Future<void> _onAddToCalendar(BuildContext context) async {
    final Calendar? calendar = await getCurrentCalendar();
    String? calendarId = calendar?.id;

    if (calendarId == null) {
      final calendar = (await deviceCalendarPlugin.createCalendar(
        "HollyBike",
        calendarColor: const Color(0xff94e2d5),
      ))
          .data;
      calendarId = calendar;
    }

    if (calendarId == null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de la création du calendrier'),
        ),
      );

      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> events = prefs.getStringList('events') ?? [];

    final eventCalendarId = await getEventCalendarId(prefs, events);

    Location currentLocation = getLocation('Europe/Paris');

    final event = Event(
      calendarId,
      eventId: eventCalendarId,
      title: eventDetails.event.name,
      description: eventDetails.event.description,
      start: TZDateTime.from(eventDetails.event.startDate, currentLocation),
      end: TZDateTime.from(endDate(), currentLocation),
      location: eventDetails.journey?.readablePartialLocation,
    );

    final createdEvent = await deviceCalendarPlugin.createOrUpdateEvent(event);

    if (createdEvent?.hasErrors == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Erreur lors de l\'ajout de l\'événement au calendrier'),
        ),
      );

      Toast.showErrorToast(context, 'Erreur lors de l\'ajout de l\'événement au calendrier');

      return;
    }

    if (context.mounted) {
      Toast.showSuccessToast(context, 'Événement ajouté au calendrier');
    }

    if (eventCalendarId == null) {
      events.add('${eventDetails.event.id}:${createdEvent!.data}');
      prefs.setStringList('events', events);
    }
  }

  DateTime endDate() {
    if (eventDetails.event.endDate != null) {
      return eventDetails.event.endDate!;
    }

    return eventDetails.event.startDate.add(const Duration(hours: 4));
  }
}
