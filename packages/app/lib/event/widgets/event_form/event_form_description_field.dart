/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

class EventFormDescriptionField extends StatelessWidget {
  final TextEditingController descriptionController;

  const EventFormDescriptionField(
      {super.key, required this.descriptionController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: descriptionController,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      autocorrect: true,
      textCapitalization: TextCapitalization.sentences,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.length > 1000) {
          return "La description ne peut pas dépasser 1000 caractères";
        }

        return null;
      },
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
    );
  }
}
