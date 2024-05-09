import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hollybike/home/widgets/app_navigation_button.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppNavigationButton(
      onLongPress: _handleLongPress,
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

  void _handleLongPress() {
    print("long press");
    HapticFeedback.heavyImpact();
  }
}
