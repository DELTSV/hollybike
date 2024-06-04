import 'package:flutter/material.dart';
import 'package:hollybike/profile/widgets/profile_button_picture.dart';
import 'package:hollybike/profile/widgets/profile_modal/profile_modal.dart';
import 'package:hollybike/shared/widgets/bar/bottom_bar_button.dart';


class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomBarButton(
      onLongPress: () => _handleLongPress(context),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProfileButtonPicture(),
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
