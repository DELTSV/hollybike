import 'package:bloc/bloc.dart';
import 'package:hollybike/profile/bloc/edit_profile_bloc/edit_profile_event.dart';
import 'package:hollybike/profile/bloc/edit_profile_bloc/edit_profile_state.dart';
import 'package:hollybike/profile/services/profile_repository.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final ProfileRepository profileRepository;

  EditProfileBloc({
    required this.profileRepository,
  }) : super(EditProfileInitial()) {
    on<SaveProfileChanges>(_onSaveProfileChanges);
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

      emit(EditProfileLoadSuccess(state));
    } catch (e) {
      emit(EditProfileLoadFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
    }
  }
}
