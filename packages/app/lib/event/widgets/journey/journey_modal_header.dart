import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_journey_bloc/event_journey_bloc.dart';
import 'package:hollybike/event/bloc/event_journey_bloc/event_journey_event.dart';
import 'package:hollybike/event/bloc/event_journey_bloc/event_journey_state.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/event/widgets/journey/journey_import_modal_from_type.dart';
import 'package:hollybike/event/widgets/journey/upload_journey_menu.dart';

enum JourneyModalAction {
  update,
  delete,
}

class JourneyModalHeader extends StatelessWidget {
  final void Function() onViewOnMap;
  final Event event;
  final bool canEditJourney;

  const JourneyModalHeader({
    super.key,
    required this.onViewOnMap,
    required this.event,
    required this.canEditJourney,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventJourneyBloc, EventJourneyState>(
      listener: (context, state) {
        if (state is EventJourneyCreationSuccess) {
          _returnToDetails(context);
        }
      },
      child: _buildHeader(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final actions = <Widget>[];

    if (canEditJourney) {
      actions.add(
        PopupMenuButton<JourneyModalAction>(
          onSelected: (action) => _onActionsSelected(
            context,
            action,
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: JourneyModalAction.update,
              child: UploadJourneyMenu(
                event: event,
                onSelection: (type) => _onUpdateJourney(
                  context,
                  type,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.swap_calls_rounded),
                    SizedBox(width: 8),
                    Text('Changer de parcours'),
                  ],
                ),
              ),
            ),
            const PopupMenuItem(
              value: JourneyModalAction.delete,
              child: Row(
                children: [
                  Icon(Icons.remove_circle),
                  SizedBox(width: 8),
                  Text('Retirer le parcours'),
                ],
              ),
            ),
          ],
        ),
      );
    }

    actions.add(
      ElevatedButton(
        onPressed: () => _onOpenMap(context),
        child: const Text('Voir sur la carte'),
      ),
    );

    return Row(
      mainAxisAlignment: actions.length > 1
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.end,
      children: actions,
    );
  }

  void _onUpdateJourney(BuildContext context, NewJourneyType type) async {
    await Navigator.of(context).maybePop();

    if (context.mounted) {
      journeyImportModalFromType(
        context,
        type,
        event,
        selected: () {
          _returnToDetails(context);
        },
      );
    }
  }

  void _onDeleteJourney(BuildContext context) {
    _returnToDetails(context);

    context.read<EventJourneyBloc>().add(
          RemoveJourneyFromEvent(
            eventId: event.id,
          ),
        );
  }

  void _onActionsSelected(BuildContext context, JourneyModalAction action) {
    if (action == JourneyModalAction.delete) {
      _onDeleteJourney(context);
    }
  }

  void _onOpenMap(BuildContext context) {
    _returnToDetails(context);

    Timer(const Duration(milliseconds: 200), () {
      onViewOnMap();
    });
  }

  void _returnToDetails(BuildContext context) {
    Timer(const Duration(milliseconds: 200), () {
      Navigator.of(context).pop();
    });
  }
}
