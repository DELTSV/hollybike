/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_bloc.dart';
import 'package:hollybike/event/bloc/event_expenses_bloc/event_expenses_bloc.dart';
import 'package:hollybike/event/services/event/event_repository.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/types/event_expense.dart';
import 'package:hollybike/event/widgets/expenses/empty_preview_expenses_card.dart';
import 'package:hollybike/event/widgets/expenses/expenses_preview_card_content.dart';

import 'expenses_modal.dart';

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
            context,
            eventDetails.expenses!,
            eventDetails.event.budget,
            eventDetails.totalExpense!,
          ),
        ),
      ],
    );
  }

  Widget _buildExpenses(
    BuildContext context,
    List<EventExpense> expenses,
    int? budget,
    int totalExpenses,
  ) {
    if (expenses.isEmpty && budget == null) {
      return EmptyPreviewExpensesCard(
        onTap: () => onTap(context),
      );
    }

    return ExpensesPreviewCardContent(
      expenses: expenses,
      budget: budget,
      totalExpenses: totalExpenses,
      onTap: () => onTap(context),
    );
  }

  void onTap(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: BlocProvider.of<EventDetailsBloc>(context),
            ),
            BlocProvider(
              create: (context) => EventExpensesBloc(
                eventId: eventDetails.event.id,
                eventRepository: RepositoryProvider.of<EventRepository>(
                  context,
                ),
              ),
            ),
          ],
          child: const ExpensesModal(),
        );
      },
    );
  }
}
