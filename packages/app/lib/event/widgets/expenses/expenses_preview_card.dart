import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/types/event_expense.dart';
import 'package:hollybike/event/widgets/expenses/empty_preview_expenses_card.dart';
import 'package:hollybike/event/widgets/expenses/expenses_preview_card_content.dart';

class ExpensesPreviewCard extends StatelessWidget {
  final EventDetails eventDetails;

  const ExpensesPreviewCard({
    super.key,
    required this.eventDetails,
  });

  @override
  Widget build(BuildContext context) {
    if (eventDetails.expenses == null && eventDetails.totalExpense == null) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          width: double.infinity,
          child: _buildExpenses(
            eventDetails.expenses!,
            eventDetails.event.budget,
            eventDetails.totalExpense!,
          ),
        ),
      ],
    );
  }

  Widget _buildExpenses(
    List<EventExpense> expenses,
    int? budget,
    int totalExpenses,
  ) {
    if (expenses.isEmpty && budget == null) {
      return const EmptyPreviewExpensesCard();
    }

    return ExpensesPreviewCardContent(
      expenses: expenses,
      budget: budget,
      totalExpenses: totalExpenses,
    );
  }
}
