/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/profile/widgets/profile_add_session_button.dart';
import 'package:hollybike/profile/widgets/profile_modal/profile_modal_list.dart';
import 'package:hollybike/theme/widgets/theme_button.dart';

class ProfileModal extends StatefulWidget {
  const ProfileModal({super.key});

  @override
  State<ProfileModal> createState() => _ProfileModalState();
}

class _ProfileModalState extends State<ProfileModal> {
  bool inEditMode = false;

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
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() {
                    inEditMode = !inEditMode;
                  }),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    padding: const EdgeInsets.all(12),
                  ),
                  child: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const ThemeButton(),
              ],
            ),
            const SizedBox(height: 15),
            ProfileModalList(inEditMode: inEditMode),
            const SizedBox(height: 15),
            const ProfileAddSessionButton(),
          ],
        ),
      ),
    );
  }
}
