import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:hollybike/profile/bloc/edit_profile_bloc/edit_profile_event.dart';
import 'package:hollybike/profile/bloc/edit_profile_bloc/edit_profile_state.dart';
import 'package:hollybike/profile/services/profile_repository.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final ProfileRepository profileRepository;

  EditProfileBloc({
    required this.profileRepository,
  }) : super(EditProfileInitial()) {
    on<SaveProfileChanges>(_onSaveProfileChanges);
    on<ChangeProfilePassword>(_onChangeProfilePassword);
    on<ResetPassword>(_onResetPassword);
  }

  Future<void> _onSaveProfileChanges(
    SaveProfileChanges event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(EditProfileLoadInProgress(state));

    try {
      await profileRepository.updateMyProfile(
        event.username,
        event.description,
        event.image,
      );

      profileRepository.invalidateCurrentProfile();
      emit(EditProfileLoadSuccess(
        state,
        successMessage: 'Profil mis à jour.',
      ));
    } catch (e) {
      emit(EditProfileLoadFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
    }
  }

  Future<void> _onChangeProfilePassword(
    ChangeProfilePassword event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(EditProfileLoadInProgress(state));

    try {
      await profileRepository.updateMyPassword(
        event.oldPassword,
        event.newPassword,
      );

      emit(
        EditProfileLoadSuccess(
          state,
          successMessage: 'Mot de passe mis à jour.',
        ),
      );
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          emit(EditProfileLoadFailure(
            state,
            errorMessage: 'Mot de passe incorrect.',
          ));
          return;
        }
      }

      emit(EditProfileLoadFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
    }
  }

  Future<void> _onResetPassword(
    ResetPassword event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(ResetPasswordInProgress(state));

    try {
      await profileRepository.resetPassword(
        event.email,
        host: event.host,
      );

      emit(
        ResetPasswordSuccess(
          state,
        ),
      );
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 503) {
          log('Reset password not available');
          emit(ResetPasswordNotAvailable(state));
          return;
        }
      }

      emit(ResetPasswordFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
    }
  }
}
