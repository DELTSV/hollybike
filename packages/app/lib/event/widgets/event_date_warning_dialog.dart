import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Future<void> showEventDateWarningDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Dates/horaires invalides'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              height: 150,
              fit: BoxFit.cover,
              'assets/lottie/lottie_calendar_error_animation.json',
              repeat: false,
            ),
            const Text(
                'La date de fin doit être postérieure à la date de début.'),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          ),
        ],
      );
    },
  );
}
