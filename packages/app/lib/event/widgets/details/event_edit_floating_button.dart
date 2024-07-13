import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_status_state.dart';

import '../../types/event.dart';
import '../../types/event_form_data.dart';
import '../event_form/event_form_modal.dart';

class EventEditFloatingButton extends StatelessWidget {
  final bool canEdit;
  final Event event;
  final void Function(EventFormData formData) onEdit;

  const EventEditFloatingButton({
    super.key,
    required this.onEdit,
    required this.canEdit,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    if (!canEdit) return const SizedBox();

    return FloatingActionButton.extended(
      onPressed: () => _onOpenEditModal(context),
      label: Text(
        'Modifier',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
      icon: const Icon(Icons.edit),
    );
  }

  void _onOpenEditModal(BuildContext context) {
    Timer(const Duration(milliseconds: 100), () {
      showModalBottomSheet<void>(
        context: context,
        enableDrag: false,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return EventFormModal(
            canEditDates: event.status == EventStatusState.pending ||
                event.status == EventStatusState.scheduled,
            initialData: EventFormData(
              name: event.name,
              description: event.description,
              startDate: event.startDate,
              endDate: event.endDate,
            ),
            onSubmit: onEdit,
            submitButtonText: 'Sauvegarder',
          );
        },
      );
    });
  }
}
