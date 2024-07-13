
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
  EditProfileLoadSuccess(EditProfileState state)
      : super.state(state.copyWith(status: EditProfileStatus.success));
}

class EditProfileLoadFailure extends EditProfileState {
  final String errorMessage;

  EditProfileLoadFailure(EditProfileState state,
      {required this.errorMessage})
      : super.state(state.copyWith(status: EditProfileStatus.error));
}
