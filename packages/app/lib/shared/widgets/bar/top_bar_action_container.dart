import 'package:flutter/material.dart';

class TopBarActionContainer extends StatelessWidget {
  final void Function()? onPressed;
  final Widget? child;

  const TopBarActionContainer({
    super.key,
    this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Ink(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary,
          border: Border.all(
            width: 2,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        child: InkWell(
          onTap: onPressed,
          child: child,
        ),
      ),
    );
  }
}
