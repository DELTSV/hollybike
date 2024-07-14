import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hollybike/profile/widgets/profile_modal/profile_modal.dart';
import 'package:hollybike/shared/widgets/bloc_provided_builder.dart';

import '../../event/widgets/event_loading_profile_picture.dart';
import '../bloc/profile_bloc/profile_bloc.dart';

class ProfileBottomBarButton extends StatelessWidget {
  final bool isSelected;
  final Color color;
  final double size;

  const ProfileBottomBarButton({
    super.key,
    this.isSelected = false,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return _renderProfilePicture(context);
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
            return _profilePictureContainer(
              context,
              UserProfilePicture(
                url: currentProfile.profile.profilePicture,
                profilePictureKey: currentProfile.profile.profilePictureKey,
                radius: size * 0.5,
                isLoading: false,
              ),
            );
          }

          return _profilePictureContainer(
            context,
            UserProfilePicture(
              url: null,
              profilePictureKey: null,
              radius: size * 0.5,
              isLoading: true,
            ),
          );
        },
      ),
    );
  }

  Widget _profilePictureContainer(
    BuildContext context,
    Widget child,
  ) {
    return Center(
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
          shape: BoxShape.circle,
        ),
        child: child,
      ),
    );
  }
}
