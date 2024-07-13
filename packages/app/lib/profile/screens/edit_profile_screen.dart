import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/image/type/image_picker_mode.dart';
import 'package:hollybike/image/widgets/image_picker/image_picker_modal.dart';
import 'package:hollybike/profile/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:hollybike/profile/bloc/edit_profile_bloc/edit_profile_event.dart';
import 'package:hollybike/profile/bloc/edit_profile_bloc/edit_profile_state.dart';
import 'package:hollybike/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:hollybike/profile/services/profile_repository.dart';
import 'package:hollybike/profile/widgets/profile_banner/profile_banner_background.dart';
import 'package:hollybike/profile/widgets/profile_banner/profile_banner_decoration.dart';
import 'package:hollybike/profile/widgets/profile_picture_image_picker.dart';
import 'package:hollybike/shared/widgets/app_toast.dart';
import 'package:hollybike/shared/widgets/bar/top_bar.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_action_icon.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_title.dart';
import 'package:hollybike/shared/widgets/hud/hud.dart';
import 'package:hollybike/shared/widgets/profile_pictures/profile_picture.dart';
import 'package:hollybike/user/types/minimal_user.dart';

@RoutePage()
class EditProfileScreen extends StatefulWidget implements AutoRouteWrapper {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();

  @override
  Widget wrappedRoute(context) {
    return BlocProvider(
      create: (context) => EditProfileBloc(
        profileRepository: context.read<ProfileRepository>(),
      ),
      child: this,
    );
  }
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  MinimalUser? _currentProfile;
  late final TextEditingController _usernameController;
  late final TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  OverlayEntry? _overlay;

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController();
    _descriptionController = TextEditingController();

    final bloc = context.read<ProfileBloc>();
    final currentProfileEvent = bloc.currentProfile;

    if (currentProfileEvent is ProfileLoadSuccessEvent) {
      _usernameController.text = currentProfileEvent.profile.username;
      _currentProfile = currentProfileEvent.profile.toMinimalUser();
    }
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final description = _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text;

      context.read<EditProfileBloc>().add(
            SaveProfileChanges(
              username: _usernameController.text,
              description: description,
              image: _selectedImage,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileBloc, EditProfileState>(
      listener: (context, state) {
        if (_overlay != null) {
          _overlay!.remove();
        }

        if (state is EditProfileLoadFailure) {
          Toast.showErrorToast(context, state.errorMessage);
        }

        if (state is EditProfileLoadInProgress) {
          _overlay = OverlayEntry(
            builder: (context) {
              return Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            },
          );

          if (_overlay != null) {
            Overlay.of(context).insert(_overlay!);
          }
        }

        if (state is EditProfileLoadSuccess) {
          Toast.showSuccessToast(context, "Votre profil a été mis à jour.");
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Hud(
          appBar: TopBar(
            prefix: TopBarActionIcon(
              icon: Icons.arrow_back,
              onPressed: () => context.router.maybePop(),
            ),
            title: const TopBarTitle('Modifier mon profil'),
            suffix: state is EditProfileLoadInProgress
                ? null
                : TopBarActionIcon(
                    icon: Icons.save,
                    onPressed: _onSubmit,
                    colorInverted: true,
                  ),
          ),
          body: Builder(builder: (context) {
            final currentProfile = _currentProfile;

            if (currentProfile == null) {
              return const SizedBox();
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      const ProfileBannerBackground(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ProfileBannerDecoration(
                            profilePicture: ProfilePicture(
                              profile: currentProfile,
                              file: _selectedImage,
                              size: 100,
                              editMode: true,
                              onTap: _showImagePickerModal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            keyboardType: TextInputType.name,
                            autocorrect: true,
                            textCapitalization:
                            TextCapitalization.sentences,
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.length > 1000) {
                                return "Le nom d'utilisateur ne peut pas dépasser 1000 caractères.";
                              }

                              if (value.isEmpty) {
                                return "Le nom d'utilisateur ne peut pas être vide.";
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              labelText: "Nom d'utilisateur",
                              fillColor:
                              Theme.of(context).colorScheme.primary,
                              filled: true,
                              suffixIcon:
                              const Icon(Icons.account_circle_rounded),
                            ),
                          ),
                          const SizedBox(height: 32),
                          TextFormField(
                            controller: _descriptionController,
                            autocorrect: true,
                            textCapitalization:
                            TextCapitalization.sentences,
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.length > 255) {
                                return "Votre description ne peut pas dépasser 255 caractères.";
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              labelText: "Description (facultatif)",
                              fillColor:
                              Theme.of(context).colorScheme.primary,
                              filled: true,
                              suffixIcon: const Icon(Icons.description),
                            ),
                          ),
                          const SizedBox(height: 32),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Changer votre mot de passe'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  void _showImagePickerModal() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return ProfilePictureImagePickerModal(
          onImageSelected: (file) {
            setState(() {
              _selectedImage = file;
            });
          },
        );
      },
    );
  }
}
