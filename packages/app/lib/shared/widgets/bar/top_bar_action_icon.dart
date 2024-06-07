import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_action_container.dart';

class TopBarActionIcon extends StatelessWidget {
  final void Function() onPressed;
  final IconData icon;

  const TopBarActionIcon({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TopBarActionContainer(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Icon(icon),
      ),
    );
  }
}
