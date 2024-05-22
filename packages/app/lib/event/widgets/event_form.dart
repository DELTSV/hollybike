import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hollybike/event/widgets/event_date_input.dart';
import 'package:hollybike/event/widgets/event_date_range_input.dart';
import 'package:hollybike/event/widgets/event_time_input.dart';

import '../../shared/utils/dates.dart';
import 'event_date_warning_dialog.dart';
import 'event_select_end_date_switch.dart';

class EventForm extends StatefulWidget {
  final void Function() scrollToBottom;

  const EventForm({super.key, required this.scrollToBottom});

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  var _dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  var _date = DateTime.now();

  var _startTime = TimeOfDay.now();

  var _endTime = TimeOfDay.now();

  var _selectEndDate = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _endTime = initialEndTime;
  }

  TimeOfDay get initialEndTime {
    return _startTime.hour == 23
        ? const TimeOfDay(hour: 23, minute: 59)
        : _startTime.replacing(hour: _startTime.hour + 1);
  }

  String formatTime(TimeOfDay time) {
    return time.format(context);
  }

  void _onDateRangeChanged(DateTimeRange dateRange) {
    setState(() {
      _dateRange = dateRange;
    });
  }

  void _onDateChanged(DateTime date) {
    setState(() {
      _date = date;
    });
  }

  void _onStartTimeChanged(TimeOfDay time) {
    if (checkSameDate(_dateRange.start, _dateRange.end)) {
      if (time.hour > _endTime.hour ||
          time.hour == _endTime.hour && time.minute >= _endTime.minute) {
        if (time.hour == 23) {
          if (time.minute == 59) {
            showEventDateWarningDialog(context);
            return;
          }

          _onEndTimeChanged(const TimeOfDay(hour: 23, minute: 59));
        } else {
          _onEndTimeChanged(_endTime.replacing(hour: time.hour + 1));
        }
      }
    }

    setState(() {
      _startTime = time;
    });
  }

  void _onEndTimeChanged(TimeOfDay time) {
    if (checkSameDate(_dateRange.start, _dateRange.end)) {
      if (time.hour < _startTime.hour ||
          time.hour == _startTime.hour && time.minute <= _startTime.minute) {
        showEventDateWarningDialog(context);
        return;
      }
    }

    setState(() {
      _endTime = time;
    });
  }

  void _onSelectEndDateSwitchChanged(bool value) {
    if (value) {
      Timer(const Duration(milliseconds: 100), () {
        widget.scrollToBottom();
      });
    }

    setState(() {
      _selectEndDate = value;
    });
  }

  Widget buildDatesInputs() {
    if (_selectEndDate) {
      return Column(
        children: [
          EventDateRangeInput(
            dateRange: _dateRange,
            onDateRangeChanged: _onDateRangeChanged,
          ),
          const SizedBox(height: 15),
          // Start and end date pickers, use showDatePicker
          EventTimeInput(
            date: _dateRange.start,
            label: "Heure de début",
            time: _startTime,
            onTimeChanged: _onStartTimeChanged,
          ),
          const SizedBox(height: 15),
          EventTimeInput(
            date: _dateRange.end,
            label: "Heure de fin",
            time: _endTime,
            onTimeChanged: _onEndTimeChanged,
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 180,
          child: EventDateInput(
            date: _date,
            onDateChanged: _onDateChanged,
          ),
        ),
        EventTimeInput(
          label: "Heure",
          time: _startTime,
          onTimeChanged: _onStartTimeChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              labelText: "Nom de l'événement",
              fillColor: Theme.of(context).colorScheme.primaryContainer,
              filled: true,
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _descriptionController,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              labelText: "Description (optionnel)",
              fillColor: Theme.of(context).colorScheme.primaryContainer,
              filled: true,
              suffixIcon: const Icon(Icons.description),
            ),
          ),
          const SizedBox(height: 10),
          EventSelectEndDateSwitch(
            value: _selectEndDate,
            onChange: () {
              _onSelectEndDateSwitchChanged(!_selectEndDate);
            },
          ),
          const SizedBox(height: 15),
          buildDatesInputs(),
        ],
      ),
    );
  }
}
