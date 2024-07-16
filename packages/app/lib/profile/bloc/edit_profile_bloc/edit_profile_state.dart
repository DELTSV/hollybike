/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/

import 'package:flutter/foundation.dart';

enum EditProfileStatus { loading, success, error, initial }

@immutable
class EditProfileState {
  final EditProfileStatus status;

  const EditProfileState({
    this.status = EditProfileStatus.initial,
  });

  EditProfileState.state(EditProfileState state)
      : this(
    status: state.status,
  );

  EditProfileState copyWith({
    EditProfileStatus? status,
  }) {
    return EditProfileState(
      status: status ?? this.status,
    );
  }
}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoadInProgress extends EditProfileState {
  EditProfileLoadInProgress(EditProfileState state)
      : super.state(state.copyWith(status: EditProfileStatus.loading));
}

class EditProfileLoadSuccess extends EditProfileState {
  final String successMessage;

  EditProfileLoadSuccess(EditProfileState state, {required this.successMessage})
      : super.state(state.copyWith(status: EditProfileStatus.success));
}

class EditProfileLoadFailure extends EditProfileState {
  final String errorMessage;

  EditProfileLoadFailure(EditProfileState state,
      {required this.errorMessage})
      : super.state(state.copyWith(status: EditProfileStatus.error));
}

class ResetPasswordNotAvailable extends EditProfileState {
  ResetPasswordNotAvailable(EditProfileState state)
      : super.state(state.copyWith(status: EditProfileStatus.error));
}

class ResetPasswordSuccess extends EditProfileState {
  ResetPasswordSuccess(EditProfileState state)
      : super.state(state.copyWith(status: EditProfileStatus.success));
}

class ResetPasswordInProgress extends EditProfileState {
  ResetPasswordInProgress(EditProfileState state)
      : super.state(state.copyWith(status: EditProfileStatus.loading));
}

class ResetPasswordFailure extends EditProfileState {
  final String errorMessage;

  ResetPasswordFailure(EditProfileState state,
      {required this.errorMessage})
      : super.state(state.copyWith(status: EditProfileStatus.error));
}