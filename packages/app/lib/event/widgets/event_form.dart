import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hollybike/event/widgets/event_date_input.dart';
import 'package:hollybike/event/widgets/event_date_range_input.dart';
import 'package:hollybike/event/widgets/event_form_description_field.dart';
import 'package:hollybike/event/widgets/event_form_name_field.dart';
import 'package:hollybike/event/widgets/event_time_input.dart';

import '../../shared/utils/dates.dart';
import 'event_date_warning_dialog.dart';
import 'event_select_end_date_switch.dart';

class EventForm extends StatefulWidget {
  final void Function(
    String name,
    String? description,
    DateTime startDate,
    DateTime? endDate,
  ) onSubmit;

  final void Function() onClose;
  final void Function() onTouched;

  final String submitButtonText;

  const EventForm({
    super.key,
    required this.onTouched,
    required this.onSubmit,
    required this.onClose,
    required this.submitButtonText,
  });

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  var _dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  var _date = DateTime.now();
  var _startTime = TimeOfDay.now();
  var _endTime = TimeOfDay.now();
  var _selectEndDate = false;

  var touched = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (DateTime.now().hour >= 22) {
      _date = DateTime.now().add(const Duration(days: 1));
      _startTime = const TimeOfDay(hour: 8, minute: 30);
    }

    _dateRange = DateTimeRange(
      start: _date,
      end: _date,
    );

    _endTime = _startTime.replacing(hour: _startTime.hour + 1);

    _nameController.addListener(_onTouch);
    _descriptionController.addListener(_onTouch);
  }

  void _onTouch() {
    if (!touched) {
      touched = true;
      widget.onTouched();
    }
  }

  void _onDateRangeChanged(DateTimeRange dateRange) {
    _onTouch();

    setState(() {
      _dateRange = dateRange;
      _date = _dateRange.start;
    });
  }

  void _onDateChanged(DateTime date) {
    _onTouch();

    setState(() {
      _date = date;
      _dateRange = DateTimeRange(
        start: date,
        end: date,
      );
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

    _onTouch();

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
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      });
    }

    _onTouch();

    setState(() {
      _selectEndDate = value;
    });
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_dateRange.start.isBefore(DateTime.now())) {
        showEventDateWarningDialog(context);
        return;
      }

      final description = _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : null;

      final startDate = _dateRange.start.copyWith(
        hour: _startTime.hour,
        minute: _startTime.minute,
      );

      final endDate = _selectEndDate
          ? _dateRange.end.copyWith(
              hour: _endTime.hour,
              minute: _endTime.minute,
            )
          : null;

      widget.onSubmit(
        _nameController.text,
        description,
        startDate,
        endDate,
      );
    }
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: widget.onClose,
            ),
            ElevatedButton(
              onPressed: () {
                _onSubmit();
              },
              child: Text(widget.submitButtonText),
            )
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 15,
                top: 12,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EventFormNameField(nameController: _nameController),
                    const SizedBox(height: 15),
                    EventFormDescriptionField(
                      descriptionController: _descriptionController,
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
              ),
            ),
          ),
        ),
      ],
    );
  }
}
