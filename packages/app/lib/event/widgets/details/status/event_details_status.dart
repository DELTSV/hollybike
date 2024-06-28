import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/types/event_status_state.dart';

import '../../../bloc/event_details_bloc/event_details_bloc.dart';
import '../../../bloc/event_details_bloc/event_details_state.dart';
import '../../../types/event.dart';
import '../../event_dot.dart';

class EventDetailsStatusBadge extends StatelessWidget {
  final void Function()? onAction;
  final String? actionText;
  final bool loading;
  final EventStatusState status;
  final String message;

  const EventDetailsStatusBadge({
    super.key,
    this.loading = false,
    required this.message,
    required this.status,
    this.onAction,
    this.actionText,
  });

  bool isLoading(EventDetailsState state) {
    return state is EventOperationInProgress || loading;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventDetailsBloc, EventDetailsState>(
      builder: (context, state) {
        return Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          EventDot(
                            size: 15,
                            status: status,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              message,
                              style: Theme.of(context).textTheme.bodyMedium,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: _buildAction(context, isLoading(state)),
                    )
                  ],
                ),
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: isLoading(state) ? 1 : 0,
              child: const LinearProgressIndicator(),
            )
          ],
        );
      },
    );
  }

  Widget _buildAction(BuildContext context, bool isLoading) {
    if (actionText == null || onAction == null) {
      return const SizedBox();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 16),
        Flexible(
          child: TextButton(
            onPressed: !isLoading ? onAction : null,
            child: Text(
              actionText!,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: !isLoading
                        ? Event.getStatusColor(status)
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
