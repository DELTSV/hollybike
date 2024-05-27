import 'package:flutter/material.dart';

class EventFormNameField extends StatelessWidget {
  final TextEditingController nameController;

  const EventFormNameField({
    super.key,
    required this.nameController,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,
      autocorrect: true,
      textCapitalization: TextCapitalization.sentences,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return "Veuillez entrer un nom pour l'événement";
        }

        if (value.length < 3) {
          return "Le nom de l'événement doit contenir au moins 3 caractères";
        }

        if (value.length > 100) {
          return "Le nom de l'événement ne peut pas dépasser 100 caractères";
        }

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        labelText: "Nom de l'événement",
        fillColor: Theme.of(context).colorScheme.primaryContainer,
        filled: true,
      ),
    );
  }
}
