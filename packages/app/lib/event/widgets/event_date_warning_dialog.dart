import 'package:flutter/material.dart';

Future<void> showEventDateWarningDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Dates/horaires invalides'),
        content: const Text(
            'La date de fin doit être postérieure à la date de début.'),
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
