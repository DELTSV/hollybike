import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/profile/types/profile.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileSave>((event, emit) {
      emit(
        ProfileSaving(
          oldState: state,
          session: event.session,
          profile: event.profile,
        ),
      );
    });
  }
}
