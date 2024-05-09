import 'package:flutter/material.dart';
import 'package:hollybike/profile/widgets/profile_button.dart';

class HudBottomBar extends StatelessWidget {
  const HudBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(
          width: 2,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        child: Ink(
          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16)), color: Colors.red,),
          child: const Row(
            children: [
              ProfileButton(),
            ],
          ),
        ),
      ),
    );
  }
}
