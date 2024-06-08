import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/profile/bloc/profile_bloc.dart';
import 'package:hollybike/profile/widgets/profile_modal/profile_modal.dart';

import '../../event/widgets/event_loading_profile_picture.dart';

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
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return GestureDetector(
          onLongPress: () => _handleLongPress(context),
          child: EventLoadingProfilePicture(
            url: state.currentProfile?.profilePicture,
            radius: 12,
            isLoading: state.currentProfile == null,
            userId: state.currentProfile?.id,
          ),
        );
      },
    );
  }
}
