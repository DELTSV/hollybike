import 'package:flutter/material.dart';

class BarContainer extends StatelessWidget {
  final Widget child;

  const BarContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.primary,
        ),
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 2,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: child,
      ),
    );
  }
}
