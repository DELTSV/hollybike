/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/association/types/association.dart';
import 'package:hollybike/profile/widgets/profile_description/profile_description_spec.dart';
import 'package:hollybike/shared/utils/add_separators.dart';
import 'package:hollybike/user/types/minimal_user.dart';

class ProfileDescription extends StatelessWidget {
  final MinimalUser profile;
  final Association association;
  final String? email;

  const ProfileDescription({
    super.key,
    required this.profile,
    required this.association,
    this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: addSeparators(
          [
            Hero(
              tag: "user-${profile.id}-username",
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  profile.username,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            if (email != null)
              ProfileDescriptionSpec(
                icon: Icons.email,
                text: email!,
              ),
            ProfileDescriptionSpec(
              icon: Icons.groups,
              text: '${association.name}, ${profile.role ?? "Membre"}',
            ),
          ],
          const SizedBox.square(dimension: 8),
        ),
      ),
    );
  }
}
