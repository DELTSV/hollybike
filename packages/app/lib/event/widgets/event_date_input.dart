import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../shared/utils/dates.dart';

class EventDateInput extends StatelessWidget {
  final DateTime date;
  final void Function(DateTime) onDateChanged;

  const EventDateInput({
    super.key,
    required this.date,
    required this.onDateChanged,
  });

  String formatDate(DateTime date) {
    DateTime today = DateTime.now();
    DateFormat fullDateFormatter = DateFormat.yMMMMd();

    if (checkSameDate(date, today)) {
      return "Aujourd'hui";
    } else {
      return "Le ${fullDateFormatter.format(date)}";
    }
  }

  void _onDateChanged(DateTime? date) {
    if (date != null) {
      onDateChanged(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: Stack(
        children: [
          TextField(
            controller: TextEditingController(text: formatDate(date)),
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              labelText: "Date",
              fillColor: Theme.of(context).colorScheme.primaryContainer,
              filled: true,
              suffixIcon: const Icon(Icons.today),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Timer(const Duration(milliseconds: 200), () {
                  showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  ).then(_onDateChanged);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
