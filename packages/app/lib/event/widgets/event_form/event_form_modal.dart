import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_form_data.dart';
import 'package:hollybike/event/widgets/event_form/event_form.dart';

import 'event_discard_changes_dialog.dart';

class EventFormModal extends StatefulWidget {
  final void Function(EventFormData) onSubmit;
  final String submitButtonText;
  final EventFormData? initialData;

  const EventFormModal({
    super.key,
    required this.onSubmit,
    required this.submitButtonText,
    this.initialData,
  });

  @override
  State<EventFormModal> createState() => _EventFormModalState();
}

class _EventFormModalState extends State<EventFormModal> {
  var touched = false;

  @override
  Widget build(BuildContext context) {
    final border = BorderSide(
      color: Theme.of(context).colorScheme.onPrimary,
      width: 3,
    );

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: PopScope(
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
            child: SafeArea(
              child: EventForm(
                submitButtonText: widget.submitButtonText,
                initialData: widget.initialData,
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
                onSubmit: widget.onSubmit,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
