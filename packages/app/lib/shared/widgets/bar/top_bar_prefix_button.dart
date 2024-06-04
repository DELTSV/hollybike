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
        padding: const EdgeInsets.all(13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      color: Theme.of(context).colorScheme.primary,
      iconSize: 32,
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}
