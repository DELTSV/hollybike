import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventTimeInput extends StatelessWidget {
  final TimeOfDay time;
  final String label;
  final Function(TimeOfDay) onTimeChanged;
  final DateTime? date;

  const EventTimeInput({
    super.key,
    required this.time,
    required this.onTimeChanged,
    required this.label,
    this.date,
  });

  void _onTimeChanged(TimeOfDay? time) {
    if (time != null) {
      onTimeChanged(time);
    }
  }

  String formatDate(DateTime date) {
    DateFormat fullDateFormatter = DateFormat.yMMMEd();
    return "Le ${fullDateFormatter.format(date)}";
  }

  Widget getText() {
    if (date == null) {
      return const SizedBox();
    } else {
      return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(formatDate(date!)),
            const Text("à"),
            const SizedBox(),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        getText(),
        SizedBox(
          height: 56,
          width: 120,
          child: Stack(
            children: [
              TextField(
                controller: TextEditingController(text: time.format(context)),
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  labelText: label,
                  fillColor: Theme.of(context).colorScheme.primaryContainer,
                  filled: true,
                  suffixIcon: const Icon(Icons.access_time),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Timer(const Duration(milliseconds: 200), () {
                      showTimePicker(
                        context: context,
                        initialTime: time,
                      ).then(_onTimeChanged);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
