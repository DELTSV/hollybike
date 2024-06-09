import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hollybike/profile/widgets/profile_modal/profile_modal.dart';
import 'package:hollybike/shared/widgets/bloc_provided_builder.dart';

import '../../event/widgets/event_loading_profile_picture.dart';
import '../bloc/profile_bloc.dart';

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
        child: _renderProfilePicture(),
      ),
      icon: _renderProfilePicture(),
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

  Widget _renderProfilePicture() {
    return BlocProvidedBuilder<ProfileBloc, ProfileState>(
      builder: (context, bloc, state) {
        return GestureDetector(
          onLongPress: () => _handleLongPress(context),
          child: EventLoadingProfilePicture(
            url: bloc.currentProfile?.profilePicture,
            radius: 12,
            isLoading: bloc.currentProfile == null,
            userId: bloc.currentProfile?.id,
          ),
        );
      },
    );
  }
}
