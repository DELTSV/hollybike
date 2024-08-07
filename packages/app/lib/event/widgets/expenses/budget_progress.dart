/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_expense.dart';
import 'package:hollybike/shared/widgets/gradient_progress_bar.dart';

class BudgetProgress extends StatelessWidget {
  final List<EventExpense> expenses;
  final int? budget;
  final int totalExpenses;
  final bool animateStart;

  const BudgetProgress({
    super.key,
    required this.expenses,
    required this.budget,
    required this.totalExpenses,
    this.animateStart = true,
  });

  @override
  Widget build(BuildContext context) {
    final expensesInEuro = totalExpenses.toDouble() / 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: '${_getExpensesTitle()} - ',
            children: [
              TextSpan(
                text: expensesInEuro.toStringAsFixed(2),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const TextSpan(
                text: ' €',
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        GradientProgressBar(
          animateStart: animateStart,
          maxValue: budget?.toDouble() ?? 1,
          value: budget == null ? 0 : expensesInEuro,
          colors: [
            Colors.green.shade400,
            Colors.yellow.shade400,
            Colors.red.shade400,
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [_getBudgetTitle(context)],
        )
      ],
    );
  }

  Widget _getBudgetTitle(BuildContext context) {
    if (budget == null) {
      return const Text('Aucun budget renseigné');
    }

    return Text.rich(
      TextSpan(
        text: 'Budget - ',
        children: [
          TextSpan(
            text: budget?.toStringAsFixed(2),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const TextSpan(
            text: ' €',
          ),
        ],
      ),
    );
  }

  String _getExpensesTitle() {
    if (expenses.isEmpty) {
      return 'Aucune dépenses';
    }

    if (expenses.length == 1) {
      return '1 Dépense';
    }

    return '${expenses.length} Dépenses';
  }
}
