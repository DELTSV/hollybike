import 'package:flutter/material.dart';

class EventDetailsStatus extends StatelessWidget {
  final Widget? action;
  final Widget prefix;
  final String message;

  const EventDetailsStatus({
    super.key,
    this.action,
    required this.message,
    required this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 60,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child:
            Row(
              children: [
                prefix,
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
