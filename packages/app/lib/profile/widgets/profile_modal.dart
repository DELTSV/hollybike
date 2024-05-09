import 'package:flutter/material.dart';
import 'package:hollybike/profile/widgets/profile_list.dart';

class ProfileModal extends StatelessWidget {
  const ProfileModal({super.key});

  @override
  Widget build(BuildContext context) {
    const borderRadius = Radius.circular(16);
    final borderSide = BorderSide(
      width: 2,
      color: Theme.of(context).colorScheme.onPrimary,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        constraints: const BoxConstraints(minWidth: double.infinity),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.only(
            topLeft: borderRadius,
            topRight: borderRadius,
          ),
          border: Border(
            top: borderSide,
            left: borderSide,
            right: borderSide,
          ),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileList()
          ],
        ),
      ),
    );
  }
}
