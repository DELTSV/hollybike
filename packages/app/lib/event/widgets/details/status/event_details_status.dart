import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_status_state.dart';

import '../../event_dot.dart';

class EventDetailsStatus extends StatelessWidget {
  final Widget? action;
  final EventStatusState status;
  final String message;

  const EventDetailsStatus({
    super.key,
    this.action,
    required this.message,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            action == null ? const SizedBox() : const SizedBox(width: 16),
            action == null ? const SizedBox() : action!,
          ],
        ),
      ),
    );
  }
}
