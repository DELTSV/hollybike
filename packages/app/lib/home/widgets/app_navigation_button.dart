import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppNavigationButton extends StatelessWidget {
  final Widget child;

  final void Function()? onTap;
  final void Function()? onLongPress;

  const AppNavigationButton({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        child: Ink(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
          child: InkWell(
            onTap: _handleTap,
            onLongPress: _handleLongPress,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    if (onTap != null) onTap!();
  }

  void _handleLongPress() {
    HapticFeedback.heavyImpact();
    if(onLongPress != null) onLongPress!();
  }
}
