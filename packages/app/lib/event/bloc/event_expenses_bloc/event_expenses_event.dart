import 'package:flutter/cupertino.dart';

@immutable
abstract class EventExpensesEvent {}

class DeleteExpense extends EventExpensesEvent {
  final int expenseId;

  DeleteExpense({
    required this.expenseId,
  });
}

class AddExpense extends EventExpensesEvent {
  final String name;
  final int amount;
  final String? description;

  AddExpense({
    required this.name,
    required this.amount,
    required this.description,
  });
}