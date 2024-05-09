import 'package:flutter/material.dart';
import 'package:hollybike/hud/widgets/hud_button.dart';
import 'package:hollybike/profile/widgets/profile_modal.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return HudButton(
      onLongPress: () => _handleLongPress(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            height: 40,
            width: 40,
            child: Image.asset("images/placeholder_profile_picture.jpg"),
          ),
        ],
      ),
    );
  }

  void _handleLongPress(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const ProfileModal(),
    );
  }
}
