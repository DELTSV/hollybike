import 'dart:developer';

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
    on<DownloadReport>(_onDownloadReport);
    on<UploadExpenseProof>(_onUploadExpenseProof);
  }

  _onDeleteExpense(
    DeleteExpense event,
    Emitter<EventExpensesState> emit,
  ) async {
    emit(EventExpensesOperationInProgress(state));

    try {
      await eventRepository.deleteExpense(
        event.expenseId,
        eventId,
      );
    } catch (e) {
      emit(EventExpensesOperationFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }

    emit(
      EventExpensesOperationSuccess(
        state,
        successMessage: 'Dépense supprimée.',
      ),
    );
  }

  _onAddExpense(
    AddExpense event,
    Emitter<EventExpensesState> emit,
  ) async {
    emit(EventExpensesOperationInProgress(state));

    try {
      await eventRepository.addExpense(
        eventId,
        event.name,
        event.amount,
        event.description,
      );

      emit(EventExpensesOperationSuccess(
        state,
        successMessage: 'Dépense ajoutée.',
      ));
    } catch (e) {
      log("An error occurred while adding expense", error: e);

      emit(EventExpensesOperationFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
    }
  }

  _onEditBudget(
    EditBudget event,
    Emitter<EventExpensesState> emit,
  ) async {
    emit(EventExpensesOperationInProgress(state));

    try {
      await eventRepository.editBudget(
        eventId,
        event.budget,
      );

      emit(EventExpensesOperationSuccess(
        state,
        successMessage: event.successMessage,
      ));
    } catch (e) {
      log("An error occurred while editing budget", error: e);
      emit(EventExpensesOperationFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
    }
  }

  _onDownloadReport(
    DownloadReport event,
    Emitter<EventExpensesState> emit,
  ) async {
    emit(EventExpensesOperationInProgress(state));

    try {
      await eventRepository.downloadReport(
        eventId,
      );

      emit(EventExpensesOperationSuccess(
        state,
        successMessage: 'Rapport téléchargé.',
      ));
    } catch (e) {
      log("An error occurred while downloading report", error: e);
      emit(EventExpensesOperationFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
    }
  }

  _onUploadExpenseProof(
    UploadExpenseProof event,
    Emitter<EventExpensesState> emit,
  ) async {
    emit(EventExpensesOperationInProgress(state));

    try {
      await eventRepository.uploadExpenseProof(
        eventId,
        event.expenseId,
        event.image,
      );

      emit(EventExpensesOperationSuccess(
        state,
        successMessage: event.successMessage,
      ));
    } catch (e) {
      log("An error occurred while uploading expense proof", error: e);
      emit(EventExpensesOperationFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
    }
  }
}
