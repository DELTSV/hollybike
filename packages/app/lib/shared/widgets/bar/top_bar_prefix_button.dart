import 'package:flutter/material.dart';

class TopBarPrefixButton extends StatelessWidget {
  final void Function() onPressed;
  final IconData icon;

  const TopBarPrefixButton({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      color: Theme.of(context).colorScheme.primary,
      iconSize: 30,
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}
