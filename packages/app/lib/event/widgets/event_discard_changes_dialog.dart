import 'package:flutter/material.dart';

Future<void> showEventDiscardChangesDialog(BuildContext context, void Function() onConfirm) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Êtes-vous sûr de vouloir annuler ?'),
        content: const Text('Toutes les informations saisies seront perdues.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: const Text('Confirmer'),
          ),
        ],
      );
    },
  );
}
