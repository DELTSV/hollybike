import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/shared/widgets/switch_with_text.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../positions/bloc/my_position_bloc.dart';
import '../../../../positions/bloc/my_position_event.dart';
import '../../../../positions/bloc/my_position_state.dart';

class EventPositionSwitch extends StatelessWidget {
  final EventDetails eventDetails;

  const EventPositionSwitch({
    super.key,
    required this.eventDetails,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyPositionBloc, MyPositionState>(
      builder: (context, state) {
        final isLoading = state is MyPositionLoading;

        if (eventDetails.callerParticipation == null ||
            (eventDetails.callerParticipation?.journey != null &&
                !state.isRunning)) {
          return const SizedBox();
        }

        return Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            child: SizedBox(
              child: SwitchWithText(
                alignment: SwitchAlignment.right,
                text: getSwitchLabel(state.isRunning),
                value: state.isRunning,
                onChange: () => _onSelected(
                  context,
                  state.isRunning,
                  isLoading,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String getSwitchLabel(bool isRunning) {
    return isRunning
        ? 'Votre position est partagée avec les autres participants'
        : 'Le partage de votre position désactivé';
  }

  void _onSelected(BuildContext context, bool isRunning, bool isLoading) {
    if (isLoading) {
      return;
    }

    if (isRunning) {
      _cancelPositions(context);
    } else {
      _onStart(context);
    }
  }

  void _onStart(BuildContext context) async {
    if (await _checkLocationPermission() && context.mounted) {
      context.read<MyPositionBloc>().add(
            EnableSendPosition(
              eventId: eventDetails.event.id,
              eventName: eventDetails.event.name,
            ),
          );
    }
  }

  Future<bool> _checkLocationPermission() async {
    final perm = await Permission.location.request();
    await Permission.notification.request();

    return perm.isGranted;
  }

  void _cancelPositions(BuildContext context) {
    context.read<MyPositionBloc>().add(
          DisableSendPositions(),
        );
  }
}
