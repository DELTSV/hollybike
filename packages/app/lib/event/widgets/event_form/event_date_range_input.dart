import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../shared/utils/dates.dart';

class EventDateRangeInput extends StatelessWidget {
  final DateTimeRange dateRange;
  final void Function(DateTimeRange) onDateRangeChanged;

  const EventDateRangeInput({
    super.key,
    required this.dateRange,
    required this.onDateRangeChanged,
  });

  String formatDateRange(DateTimeRange dateRange) {
    DateTime start = dateRange.start;
    DateTime end = dateRange.end;
    DateTime today = DateTime.now();

    DateFormat fullDateFormatter = DateFormat.yMMMMd();
    DateFormat shortDateFormatter = DateFormat('dd/MM/yyyy');

    if (checkSameDate(start, end)) {
      if (checkSameDate(start, today)) {
        return "Aujourd'hui";
      } else {
        return "Le ${fullDateFormatter.format(start)}";
      }
    } else {
      return "Du ${shortDateFormatter.format(start)} au ${shortDateFormatter.format(end)}";
    }
  }

  void _onDateRangeChanged(DateTimeRange? dateRange) {
    if (dateRange != null) {
      onDateRangeChanged(dateRange);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: Stack(
        children: [
          TextField(
            controller: TextEditingController(text: formatDateRange(dateRange)),
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              labelText: "Plage de dates",
              fillColor: Theme.of(context).colorScheme.primaryContainer,
              filled: true,
              suffixIcon: const Icon(Icons.date_range),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Timer(const Duration(milliseconds: 200), () {
                  showDateRangePicker(
                    context: context,
                    initialDateRange: dateRange,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  ).then(_onDateRangeChanged);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
