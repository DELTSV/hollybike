import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_state.dart';
import 'package:hollybike/event/bloc/event_expenses_bloc/event_expenses_bloc.dart';
import 'package:hollybike/event/bloc/event_expenses_bloc/event_expenses_state.dart';
import 'package:hollybike/event/widgets/expenses/budget_progress.dart';
import 'package:hollybike/event/widgets/expenses/expense_card.dart';
import 'package:hollybike/event/widgets/expenses/expenses_modal_header.dart';
import 'package:hollybike/shared/widgets/app_toast.dart';

class ExpensesModal extends StatelessWidget {
  const ExpensesModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventExpensesBloc, EventExpensesState>(
      listener: (context, state) {
        if (state is EventExpensesOperationSuccess) {
          Toast.showSuccessToast(context, state.successMessage);
        }

        if (state is EventExpensesOperationFailure) {
          Toast.showErrorToast(context, state.errorMessage);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(31),
            topRight: Radius.circular(31),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
          ),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: 550,
              child: BlocBuilder<EventDetailsBloc, EventDetailsState>(
                builder: (context, state) {
                  final eventName = state.eventDetails?.event.name;
                  final expenses = state.eventDetails?.expenses;
                  final budget = state.eventDetails?.event.budget;
                  final totalExpenses = state.eventDetails?.totalExpense;

                  if (expenses == null ||
                      totalExpenses == null ||
                      eventName == null) {
                    return const SizedBox();
                  }

                  return Column(
                    children: [
                      ExpensesModalHeader(
                        budget: budget,
                        expenses: expenses,
                        eventName: eventName,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        child: BudgetProgress(
                          expenses: expenses,
                          budget: budget,
                          totalExpenses: totalExpenses,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: expenses.length,
                          itemBuilder: (context, index) {
                            final expense = expenses[index];

                            return ExpenseCard(
                              expense: expense,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
