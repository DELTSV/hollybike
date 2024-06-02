import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/dialog/dialog_container.dart';

class ClosableDialog extends StatelessWidget {
  final String title;
  final Widget? body;
  final void Function() onClose;

  const ClosableDialog({
    super.key,
    required this.title,
    required this.onClose,
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    return DialogContainer(
      head: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 45),
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            IconButton(
              onPressed: onClose,
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                ),
              ),
              color: Theme.of(context).colorScheme.primary,
              icon: const Icon(Icons.close),
            )
          ],
        ),
      ),
      body: body,
    );
  }
}
