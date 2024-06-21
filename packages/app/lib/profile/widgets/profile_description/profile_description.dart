import 'package:flutter/material.dart';
import 'package:hollybike/profile/widgets/profile_description/profile_description_spec.dart';
import 'package:hollybike/shared/utils/add_separators.dart';

import '../../types/profile.dart';

class ProfileDescription extends StatelessWidget {
  final Profile profile;

  const ProfileDescription({super.key, required this.profile});

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
            ProfileDescriptionSpec(
              icon: Icons.groups,
              text: profile.association.name,
            ),
            ProfileDescriptionSpec(
              icon: Icons.alternate_email,
              text: profile.email,
            ),
          ],
          const SizedBox.square(dimension: 8),
        ),
      ),
    );
  }
}
