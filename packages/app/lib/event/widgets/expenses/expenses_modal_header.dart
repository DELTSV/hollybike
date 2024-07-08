import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_expenses_bloc/event_expenses_bloc.dart';
import 'package:hollybike/event/bloc/event_expenses_bloc/event_expenses_event.dart';
import 'package:hollybike/event/types/event_expense.dart';
import 'package:hollybike/event/widgets/expenses/edit_budget_modal.dart';

import 'add_expense_modal.dart';

enum ExpensesModalAction {
  addExpense,
  editBudget,
  addBudget,
  downloadCSV,
  removeBudget
}

class ExpensesModalHeader extends StatelessWidget {
  final int? budget;
  final List<EventExpense> expenses;
  final String eventName;

  const ExpensesModalHeader({
    super.key,
    this.budget,
    required this.expenses,
    required this.eventName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PopupMenuButton(
          onSelected: (value) {
            _onModalActionSelected(
              context,
              value,
              budget,
              eventName,
            );
          },
          itemBuilder: (context) {
            return _buildBudgetActions(budget, expenses);
          },
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () => _onModalActionSelected(
            context,
            ExpensesModalAction.addExpense,
            budget,
            eventName,
          ),
          child: const Text('Ajouter une dépense'),
        ),
      ],
    );
  }

  void _onModalActionSelected(
    BuildContext context,
    ExpensesModalAction action,
    int? budget,
    String eventName,
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
      case ExpensesModalAction.addBudget:
        showDialog(
          context: context,
          builder: (_) {
            return EditBudgetModal(
              onBudgetChange: (budget) {
                context.read<EventExpensesBloc>().add(
                      EditBudget(
                        budget: budget,
                        successMessage: 'Budget ajouté.',
                      ),
                    );
              },
              addMode: true,
            );
          },
        );
        break;
      case ExpensesModalAction.removeBudget:
        context.read<EventExpensesBloc>().add(
              EditBudget(
                budget: null,
                successMessage: 'Budget supprimé.',
              ),
            );
        break;
      case ExpensesModalAction.editBudget:
        showDialog(
          context: context,
          builder: (_) {
            return EditBudgetModal(
              budget: budget,
              onBudgetChange: (budget) {
                context.read<EventExpensesBloc>().add(
                      EditBudget(
                        budget: budget,
                        successMessage: 'Budget modifié.',
                      ),
                    );
              },
            );
          },
        );
        break;
      case ExpensesModalAction.downloadCSV:
        context.read<EventExpensesBloc>().add(
              DownloadReport(),
            );

        break;
    }
  }

  List<PopupMenuItem> _buildBudgetActions(
      int? budget, List<EventExpense> expenses) {
    final hasBudget = budget != null;

    final actions = <PopupMenuItem>[
      hasBudget
          ? const PopupMenuItem(
              value: ExpensesModalAction.editBudget,
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Modifier le budget'),
                ],
              ),
            )
          : const PopupMenuItem(
              value: ExpensesModalAction.addBudget,
              child: Row(
                children: [
                  Icon(Icons.add_circle_outline_rounded),
                  SizedBox(width: 8),
                  Text('Ajouter un budget'),
                ],
              ),
            )
    ];

    if (hasBudget) {
      actions.add(
        const PopupMenuItem(
          value: ExpensesModalAction.removeBudget,
          child: Row(
            children: [
              Icon(Icons.remove_circle_outline_rounded),
              SizedBox(width: 8),
              Text('Supprimer le budget'),
            ],
          ),
        ),
      );
    }

    if (expenses.isNotEmpty) {
      actions.add(
        const PopupMenuItem(
          value: ExpensesModalAction.downloadCSV,
          child: Row(
            children: [
              Icon(Icons.download),
              SizedBox(width: 8),
              Text('Télécharger le fichier CSV'),
            ],
          ),
        ),
      );
    }

    return actions;
  }
}
