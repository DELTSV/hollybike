import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_state.dart';
import 'package:hollybike/event/bloc/event_expenses_bloc/event_expenses_bloc.dart';
import 'package:hollybike/event/bloc/event_expenses_bloc/event_expenses_event.dart';
import 'package:hollybike/event/bloc/event_expenses_bloc/event_expenses_state.dart';
import 'package:hollybike/event/widgets/expenses/add_expense_modal.dart';
import 'package:hollybike/event/widgets/expenses/budget_progress.dart';
import 'package:hollybike/shared/widgets/app_toast.dart';

enum ExpenseAction { delete, addProof }

enum ExpensesModalAction { addExpense, editBudget, downloadCSV }

class ExpensesModal extends StatelessWidget {
  const ExpensesModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventExpensesBloc, EventExpensesState>(
      listener: (context, state) {
        if (state is EventJourneyOperationSuccess) {
          Toast.showSuccessToast(context, state.successMessage);
        }

        if (state is EventJourneyOperationFailure) {
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
                  final expenses = state.eventDetails?.expenses;
                  final budget = state.eventDetails?.event.budget;
                  final totalExpenses = state.eventDetails?.totalExpense;

                  if (expenses == null ||
                      budget == null ||
                      totalExpenses == null) {
                    return const SizedBox();
                  }

                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          PopupMenuButton(
                            itemBuilder: (context) {
                              return [
                                const PopupMenuItem(
                                  value: ExpensesModalAction.addExpense,
                                  child: Row(
                                    children: [
                                      Icon(Icons.attach_money),
                                      SizedBox(width: 8),
                                      Text('Modifier le budget'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: ExpensesModalAction.editBudget,
                                  child: Row(
                                    children: [
                                      Icon(Icons.download),
                                      SizedBox(width: 8),
                                      Text('Télécharger le fichier CSV'),
                                    ],
                                  ),
                                ),
                              ];
                            },
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () => _onModalActionSelected(
                              context,
                              ExpensesModalAction.addExpense,
                            ),
                            child: const Text('Ajouter une dépense'),
                          ),
                        ],
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

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          expense.name,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          expense.description ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    '${expense.amount.toDouble() / 100} €',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  PopupMenuButton(
                                    onSelected: (value) {
                                      if (value == ExpenseAction.delete) {
                                        context.read<EventExpensesBloc>().add(
                                              DeleteExpense(
                                                expenseId: expense.id,
                                              ),
                                            );
                                      }
                                    },
                                    itemBuilder: (context) {
                                      return [
                                        const PopupMenuItem(
                                          value: ExpenseAction.addProof,
                                          child: Row(
                                            children: [
                                              Icon(Icons.photo_album_rounded),
                                              SizedBox(width: 8),
                                              Text(
                                                'Ajouter une preuve de paiement',
                                              ),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: ExpenseAction.delete,
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete),
                                              SizedBox(width: 8),
                                              Text('Supprimer'),
                                            ],
                                          ),
                                        ),
                                      ];
                                    },
                                  ),
                                ],
                              ),
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

  void _onModalActionSelected(
    BuildContext context,
    ExpensesModalAction action,
  ) {
    switch (action) {
      case ExpensesModalAction.addExpense:
        showDialog(
          context: context,
          builder: (_) {
            return AddExpenseModal(onAddExpense: (name, amount, description) {
              context.read<EventExpensesBloc>().add(
                    AddExpense(
                      name: name,
                      amount: amount,
                      description: description,
                    ),
                  );
            });
          },
        );
        break;
      case ExpensesModalAction.editBudget:
        print('Edit budget');
        break;
      case ExpensesModalAction.downloadCSV:
        print('Download CSV');
        break;
    }
  }
}