import 'package:flutter/material.dart';

class EventWarning extends StatelessWidget {
  final void Function()? onAction;
  final String message;
  final Color color;
  final String? actionText;

  const EventWarning({
    super.key,
    this.onAction,
    required this.message,
    this.actionText,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(message),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                surfaceTintColor: color,
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onAction,
              child: actionText != null ? Text(actionText!) : null,
            ),
          ],
        ),
      ),
    );
  }
}
