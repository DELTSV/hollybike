import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/user_journey/bloc/user_journey_details_event.dart';
import 'package:hollybike/user_journey/bloc/user_journey_details_state.dart';

import '../services/user_journey_repository.dart';

class UserJourneyDetailsBloc
    extends Bloc<UserJourneyDetailsEvent, UserJourneyDetailsState> {
  final int numberOfUserJourneysPerRequest = 20;

  final UserJourneyRepository userJourneyRepository;
  final int journeyId;

  UserJourneyDetailsBloc({
    required this.userJourneyRepository,
    required this.journeyId,
  }) : super(UserJourneyDetailsInitial()) {
    on<DeleteUserJourney>(_onDeleteUserJourney);
    on<DownloadUserJourney>(_onDownloadUserJourney);
  }

  Future<void> _onDeleteUserJourney(
    DeleteUserJourney event,
    Emitter<UserJourneyDetailsState> emit,
  ) async {
    emit(UserJourneyOperationInProgress(state));

    try {
      await userJourneyRepository.deleteUserJourney(journeyId);
      emit(UserJourneyDeleted(state));
    } catch (e) {
      log('Failed to delete user journey', error: e);
      emit(UserJourneyOperationFailure(
        state,
        errorMessage: 'Ecchec de la suppression du parcours.',
      ));
      return;
    }
  }

  Future<void> _onDownloadUserJourney(
    DownloadUserJourney event,
    Emitter<UserJourneyDetailsState> emit,
  ) async {
    emit(UserJourneyOperationInProgress(state));

    try {
      await userJourneyRepository.downloadUserJourneyFile(
        journeyId,
        event.fileName,
      );

      emit(
        UserJourneyOperationSuccess(
          state,
          successMessage: 'Parcours téléchargé.',
        ),
      );
    } catch (e) {
      log('Failed to download user journey file', error: e);
      emit(UserJourneyOperationFailure(
        state,
        errorMessage: 'Echec du téléchargement du parcours.',
      ));
      return;
    }
  }
}
