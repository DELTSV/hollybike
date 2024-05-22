import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/widgets/event_discard_changes_dialog.dart';
import 'package:hollybike/event/widgets/event_form.dart';
import 'package:hollybike/shared/utils/with_current_session.dart';

import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';

class EventCreationModal extends StatefulWidget {
  const EventCreationModal({super.key});

  @override
  State<EventCreationModal> createState() => _EventCreationModalState();
}

class _EventCreationModalState extends State<EventCreationModal> {
  var touched = false;

  void _onSubmit(
    String name,
    String? description,
    DateTime startDate,
    DateTime? endDate,
  ) {
    withCurrentSession(context, (session) {
      context.read<EventBloc>().add(
        CreateEvent(
          session: session,
          name: name,
          description: description,
          startDate: startDate,
          endDate: endDate,
        ),
      );
    });

    Navigator.of(context).pop();
  }

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

        if (!touched) {
          Navigator.of(context).pop();
          return;
        }

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
              if (!touched) {
                Navigator.of(context).pop();
                return;
              }

              showEventDiscardChangesDialog(context, () {
                Navigator.of(context).pop();
              });
            },
            onTouched: () {
              setState(() {
                touched = true;
              });
            },
            onSubmit: _onSubmit,
          ),
        ),
      ),
    );
  }
}
