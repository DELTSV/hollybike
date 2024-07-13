import 'package:flutter/material.dart';

class DialogContainer extends StatelessWidget {
  final Widget? head;
  final Widget? body;

  const DialogContainer({
    super.key,
    this.head,
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(15);
    final border = BorderSide(
      width: 2,
      color: Theme.of(context).colorScheme.onPrimary,
    );

    return Dialog(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: const BoxConstraints.tightFor(
              width: double.infinity,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topRight: radius,
                topLeft: radius,
              ),
            ),
            foregroundDecoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: radius,
                topLeft: radius,
              ),
              border: Border(
                top: border,
                left: border,
                right: border,
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: head,
          ),
          Flexible(
            child: Container(
              constraints: const BoxConstraints.tightFor(
                width: double.infinity,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: radius,
                  bottomRight: radius,
                ),
              ),
              foregroundDecoration: BoxDecoration(
                border: Border(
                  left: border,
                  right: border,
                  bottom: border,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: radius,
                  bottomRight: radius,
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: body,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
