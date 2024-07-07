import 'package:bloc/bloc.dart';

import '../../services/event/event_repository.dart';

import 'event_expenses_event.dart';
import 'event_expenses_state.dart';

class EventExpensesBloc extends Bloc<EventExpensesEvent, EventExpensesState> {
  final int eventId;
  final EventRepository eventRepository;

  EventExpensesBloc({
    required this.eventId,
    required this.eventRepository,
  }) : super(EventJourneyInitial()) {
    on<DeleteExpense>(_onDeleteExpense);
    on<AddExpense>(_onAddExpense);
    on<EditBudget>(_onEditBudget);
  }

  _onDeleteExpense(
    DeleteExpense event,
    Emitter<EventExpensesState> emit,
  ) async {
    emit(EventJourneyOperationInProgress(state));

    try {
      await eventRepository.deleteExpense(
        event.expenseId,
        eventId,
      );
    } catch (e) {
      emit(EventJourneyOperationFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }

    emit(EventJourneyOperationSuccess(state, successMessage: 'Dépense supprimée.'));
  }

  _onAddExpense(
    AddExpense event,
    Emitter<EventExpensesState> emit,
  ) async {
    emit(EventJourneyOperationInProgress(state));

    try {
      await eventRepository.addExpense(
        eventId,
        event.name,
        event.amount,
        event.description,
      );
    } catch (e) {
      emit(EventJourneyOperationFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }

    emit(EventJourneyOperationSuccess(state, successMessage: 'Dépense ajoutée.'));
  }

  _onEditBudget(
    EditBudget event,
    Emitter<EventExpensesState> emit,
  ) async {
    emit(EventJourneyOperationInProgress(state));

    try {
      await eventRepository.editBudget(
        eventId,
        event.budget,
      );
    } catch (e) {
      emit(EventJourneyOperationFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }

    emit(EventJourneyOperationSuccess(state, successMessage: 'Budget modifié.'));
  }
}
