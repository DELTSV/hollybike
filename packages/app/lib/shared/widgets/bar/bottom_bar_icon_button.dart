import 'package:flutter/material.dart';

class BottomBarIconButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const BottomBarIconButton({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationDestination(
      selectedIcon: Icon(icon),
      icon: Icon(
        icon,
        color: Theme.of(context).colorScheme.onPrimary.withAlpha(100),
      ),
      label: label,
    );
  }
}
