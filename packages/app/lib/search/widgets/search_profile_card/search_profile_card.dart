import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/profile/types/profile.dart';
import 'package:hollybike/shared/widgets/profile_pictures/profile_picture.dart';

import '../../../app/app_router.gr.dart';

class SearchProfileCard extends StatelessWidget {
  final Profile profile;

  const SearchProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: double.infinity,
      child: Material(
        color: Theme.of(context).colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            _handleCardTap(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ProfilePicture(
                  profile: profile,
                  size: 50,
                ),
                const SizedBox.square(dimension: 8),
                Expanded(
                  child: Hero(
                    tag: "user-${profile.id}-username",
                    child: Text(
                      profile.username,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleCardTap(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        context.router.push(ProfileRoute(id: "${profile.id}"));
      },
    );
  }
}
