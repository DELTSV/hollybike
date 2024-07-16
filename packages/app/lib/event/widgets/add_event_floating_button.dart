/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/future_events_bloc.dart';

import '../bloc/events_bloc/events_event.dart';
import 'event_form/event_form_modal.dart';

class AddEventFloatingButton extends StatelessWidget {
  const AddEventFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        showModalBottomSheet<void>(
          isScrollControlled: true,
          context: context,
          enableDrag: false,
          builder: (BuildContext modalContext) {
            return EventFormModal(
              onSubmit: (formData) {
                context.read<FutureEventsBloc>().add(
                      CreateEvent(
                        formData: formData,
                      ),
                    );

                Navigator.of(modalContext).pop();
              },
              submitButtonText: 'Créer',
            );
          },
        );
      },
      label: Text(
        'Ajouter',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
      icon: const Icon(Icons.add),
    );
  }
}
