import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/journey/service/journey_repository.dart';
import 'package:hollybike/journey/type/journey.dart';

import '../../../shared/types/paginated_list.dart';
import 'journeys_library_event.dart';
import 'journeys_library_state.dart';

class JourneysLibraryBloc
    extends Bloc<JourneysLibraryEvent, JourneysLibraryState> {
  final int numberOfJourneysPerRequest = 20;

  final JourneyRepository journeyRepository;

  JourneysLibraryBloc({
    required this.journeyRepository,
  }) : super(JourneysLibraryInitial()) {
    on<LoadJourneysLibraryNextPage>(_onLoadJourneysLibraryNextPage);
    on<RefreshJourneysLibrary>(_onRefreshJourneysLibrary);
  }

  Future<void> _onLoadJourneysLibraryNextPage(
    LoadJourneysLibraryNextPage event,
    Emitter<JourneysLibraryState> emit,
  ) async {
    if (state.hasMore == false ||
        state.status == JourneysLibraryStatus.loading) {
      return;
    }

    emit(JourneysLibraryPageLoadInProgress(state));

    try {
      PaginatedList<Journey> page = await journeyRepository.fetchJourneys(
        state.nextPage,
        numberOfJourneysPerRequest,
      );

      emit(JourneysLibraryPageLoadSuccess(state.copyWith(
        journeys: [...state.journeys, ...page.items],
        hasMore: page.items.length == numberOfJourneysPerRequest,
        nextPage: state.nextPage + 1,
      )));
    } catch (e) {
      log('Error while loading next page of journeys', error: e);
      emit(JourneysLibraryPageLoadFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }

  Future<void> _onRefreshJourneysLibrary(
    RefreshJourneysLibrary event,
    Emitter<JourneysLibraryState> emit,
  ) async {
    emit(JourneysLibraryPageLoadInProgress(state));

    try {
      PaginatedList<Journey> page = await journeyRepository.refreshJourneys(
        numberOfJourneysPerRequest,
      );

      emit(JourneysLibraryPageLoadSuccess(state.copyWith(
        journeys: page.items,
        hasMore: page.items.length == numberOfJourneysPerRequest,
        nextPage: 1,
      )));
    } catch (e) {
      log('Error while refreshing journeys', error: e);
      emit(JourneysLibraryPageLoadFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }
}
