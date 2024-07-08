import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_expense.dart';
import 'package:hollybike/event/widgets/expenses/expense_actions.dart';

class ExpenseCard extends StatelessWidget {
  final EventExpense expense;

  const ExpenseCard({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.name,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.photo_album_rounded,
                      size: 14,
                      color: expense.proof != null
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.red.shade200,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      expense.proof != null
                          ? 'Avec preuve de paiement'
                          : 'Sans preuve de paiement',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '${(expense.amount.toDouble() / 100).toStringAsFixed(2)} €',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          ExpenseActions(expense: expense),
        ],
      ),
    );
  }
}
