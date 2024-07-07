import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_expense.dart';
import 'package:hollybike/event/widgets/expenses/budget_progress.dart';

class ExpensesPreviewCardContent extends StatelessWidget {
  final List<EventExpense> expenses;
  final int? budget;
  final int totalExpenses;
  final void Function() onTap;

  const ExpensesPreviewCardContent({
    super.key,
    required this.expenses,
    required this.budget,
    required this.totalExpenses,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {


    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: BudgetProgress(
            expenses: expenses,
            budget: budget,
            totalExpenses: totalExpenses,
          )
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}
