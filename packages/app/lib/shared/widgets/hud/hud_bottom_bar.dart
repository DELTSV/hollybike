import 'package:flutter/material.dart';
import 'package:hollybike/profile/widgets/profile_button.dart';

class HudBottomBar extends StatelessWidget {
  const HudBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      foregroundDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: const SafeArea(
        child: Row(
          children: [
            ProfileButton(),
          ],
        ),
      ),
    );
  }
}
