import 'package:flutter/material.dart';
import 'package:hollybike/profile/widgets/profile_add_session_button.dart';
import 'package:hollybike/profile/widgets/profile_list.dart';
import 'package:hollybike/theme/widgets/theme_button.dart';

class ProfileModal extends StatelessWidget {
  const ProfileModal({super.key});

  @override
  Widget build(BuildContext context) {
    final border = BorderSide(
      width: 3,
      color: Theme.of(context).colorScheme.onPrimary,
    );

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border(
          top: border,
          left: border,
          right: border,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(31),
          topRight: Radius.circular(31),
        ),
      ),
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints.expand(height: 350),
      child: const SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ThemeButton(),
              ],
            ),
            SizedBox(height: 15),
            ProfileList(),
            SizedBox(height: 15),
            ProfileAddSessionButton(),
          ],
        ),
      ),
    );
  }
}
