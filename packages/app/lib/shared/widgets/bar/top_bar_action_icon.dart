import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_action_container.dart';

class TopBarActionIcon extends StatelessWidget {
  final void Function() onPressed;
  final IconData icon;
  final bool colorInverted;

  const TopBarActionIcon({
    super.key,
    required this.onPressed,
    required this.icon,
    this.colorInverted = false,
  });

  @override
  Widget build(BuildContext context) {
    return TopBarActionContainer(
      colorInverted: colorInverted,
      onPressed: onPressed,
      child: Icon(
        icon,
        color: colorInverted
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
