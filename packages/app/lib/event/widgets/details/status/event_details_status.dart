import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_status_state.dart';

import '../../../types/event.dart';
import '../../event_dot.dart';

class EventDetailsStatus extends StatelessWidget {
  final void Function()? onAction;
  final String? actionText;
  final bool loading;
  final EventStatusState status;
  final String message;

  const EventDetailsStatus({
    super.key,
    this.loading = false,
    required this.message,
    required this.status,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 65,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Row(
                  children: [
                    EventDot(
                      size: 15,
                      status: status,
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Text(
                        message,
                        style: Theme.of(context).textTheme.bodyMedium,
                        softWrap: true,
                      ),
                    ),
                  ],
                )),
                _buildAction(context),
              ],
            ),
          ),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: loading ? 1 : 0,
          child: const LinearProgressIndicator(),
        )
      ],
    );
  }

  Widget _buildAction(BuildContext context) {
    if (actionText == null || onAction == null) {
      return const SizedBox();
    }

    return Column(
      children: [
        const SizedBox(width: 16),
        TextButton(
          onPressed: !loading ? onAction : null,
          child: Text(
            actionText!,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: !loading
                      ? Event.getStatusColor(status)
                      : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
          ),
        ),
      ],
    );
  }
}
