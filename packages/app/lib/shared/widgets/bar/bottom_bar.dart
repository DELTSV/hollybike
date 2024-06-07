import 'package:flutter/material.dart';
import 'package:hollybike/profile/widgets/profile_button.dart';
import 'package:hollybike/shared/widgets/bar/bar_container.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const BarContainer(
      child: Row(
        children: [
          ProfileButton(),
        ],
      ),
    );
  }
}
