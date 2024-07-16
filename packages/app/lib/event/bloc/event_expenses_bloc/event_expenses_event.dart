/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:io';

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

class EditBudget extends EventExpensesEvent {
  final String successMessage;
  final int? budget;

  EditBudget({
    required this.successMessage,
    required this.budget,
  });
}

class DownloadReport extends EventExpensesEvent {}

class UploadExpenseProof extends EventExpensesEvent {
  final String successMessage;
  final int expenseId;
  final File image;

  UploadExpenseProof({
    required this.successMessage,
    required this.expenseId,
    required this.image,
  });
}