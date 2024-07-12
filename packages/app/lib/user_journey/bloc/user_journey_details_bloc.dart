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
      emit(UserJourneyOperationSuccess(state));
    } catch (e) {
      emit(UserJourneyOperationFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
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
      final fileData =
          await userJourneyRepository.getUserJourneyFile(journeyId);

      print('File data: $fileData');

      emit(UserJourneyOperationSuccess(state));
    } catch (e) {
      emit(UserJourneyOperationFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }
}
