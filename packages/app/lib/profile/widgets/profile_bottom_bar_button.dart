import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hollybike/profile/widgets/profile_modal/profile_modal.dart';
import 'package:hollybike/shared/widgets/bloc_provided_builder.dart';

import '../../event/widgets/event_loading_profile_picture.dart';
import '../bloc/profile_bloc/profile_bloc.dart';

class ProfileBottomBarButton extends StatelessWidget {
  const ProfileBottomBarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationDestination(
      selectedIcon: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          shape: BoxShape.circle,
        ),
        child: _renderProfilePicture(context),
      ),
      icon: _renderProfilePicture(context),
      label: 'Profile',
    );
  }

  void _handleLongPress(context) {
    HapticFeedback.heavyImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const ProfileModal(),
    );
  }

  Widget _renderProfilePicture(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _handleLongPress(context),
      child: BlocProvidedBuilder<ProfileBloc, ProfileState>(
        builder: (context, bloc, state) {
          final currentProfile = bloc.currentProfile;

          if (currentProfile is ProfileLoadSuccessEvent) {
            return UserProfilePicture(
              url: currentProfile.profile.profilePicture,
              radius: 12,
              isLoading: false,
              userId: currentProfile.profile.id,
            );
          }

          return const UserProfilePicture(
            url: null,
            radius: 12,
            isLoading: true,
            userId: null,
          );
        },
      ),
    );
  }
}
