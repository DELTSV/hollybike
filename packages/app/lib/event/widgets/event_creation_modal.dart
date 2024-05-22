import 'package:flutter/material.dart';
import 'package:hollybike/event/widgets/event_discard_changes_dialog.dart';
import 'package:hollybike/event/widgets/event_form.dart';

class EventCreationModal extends StatelessWidget {
  const EventCreationModal({super.key});

  @override
  Widget build(BuildContext context) {
    final border = BorderSide(
      color: Theme.of(context).colorScheme.onPrimary,
      width: 3,
    );

    return PopScope(
      canPop: false,
      onPopInvoked: (canPop) {
        if (canPop) return;
        showEventDiscardChangesDialog(context, () {
          Navigator.of(context).pop();
        });
      },
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          border: Border(
            top: border,
            left: border,
            right: border,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(31),
            topRight: Radius.circular(31),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 18,
            left: 16,
            right: 16,
          ),
          child: EventForm(
            submitButtonText: "Créer",
            onClose: () {
              showEventDiscardChangesDialog(context, () {
                Navigator.of(context).pop();
              });
            },
            onSubmit: (
              String name,
              String? description,
              DateTime startDate,
              DateTime? endDate,
            ) {
              print("Event created");
              print("Name: $name");
              print("Description: $description");
              print("Start date: $startDate");
              print("End date: $endDate");
            },
          ),
        ),
      ),
    );
  }
}
