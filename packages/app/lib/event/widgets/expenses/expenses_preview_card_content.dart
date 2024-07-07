import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_expense.dart';
import 'package:hollybike/shared/widgets/gradient_progress_bar.dart';

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
    final expensesInEuro = totalExpenses.toDouble() / 100;

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
          child: Column(
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
                maxValue: budget?.toDouble() ?? 0,
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
          ),
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
