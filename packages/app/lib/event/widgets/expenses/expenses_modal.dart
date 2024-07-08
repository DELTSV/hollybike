import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_state.dart';
import 'package:hollybike/event/bloc/event_expenses_bloc/event_expenses_bloc.dart';
import 'package:hollybike/event/bloc/event_expenses_bloc/event_expenses_event.dart';
import 'package:hollybike/event/bloc/event_expenses_bloc/event_expenses_state.dart';
import 'package:hollybike/event/types/event_expense.dart';
import 'package:hollybike/event/widgets/expenses/add_expense_modal.dart';
import 'package:hollybike/event/widgets/expenses/budget_progress.dart';
import 'package:hollybike/event/widgets/expenses/edit_budget_modal.dart';
import 'package:hollybike/event/widgets/expenses/expenses_image_picker_modal.dart';
import 'package:hollybike/shared/widgets/app_toast.dart';
import 'package:photo_view/photo_view.dart';

enum ExpenseAction { delete, addProof, seeProof }

enum ExpensesModalAction {
  addExpense,
  editBudget,
  addBudget,
  downloadCSV,
  removeBudget
}

class ExpensesModal extends StatelessWidget {
  const ExpensesModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventExpensesBloc, EventExpensesState>(
      listener: (context, state) {
        if (state is EventExpensesOperationSuccess) {
          Toast.showSuccessToast(context, state.successMessage);
        }

        if (state is EventExpensesOperationFailure) {
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
                  final eventName = state.eventDetails?.event.name;
                  final expenses = state.eventDetails?.expenses;
                  final budget = state.eventDetails?.event.budget;
                  final totalExpenses = state.eventDetails?.totalExpense;

                  if (expenses == null ||
                      totalExpenses == null ||
                      eventName == null) {
                    return const SizedBox();
                  }

                  return Column(
                    children: [
                      Row(
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
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.photo_album_rounded,
                                              size: 14,
                                              color: expense.proof != null
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .secondary
                                                  : Colors.red.shade200,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              expense.proof != null
                                                  ? 'Avec preuve de paiement'
                                                  : 'Sans preuve de paiement',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    '${(expense.amount.toDouble() / 100).toStringAsFixed(2)} €',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  PopupMenuButton(
                                    onSelected: (value) {
                                      switch (value) {
                                        case ExpenseAction.delete:
                                          context.read<EventExpensesBloc>().add(
                                                DeleteExpense(
                                                  expenseId: expense.id,
                                                ),
                                              );
                                          break;
                                        case ExpenseAction.addProof:
                                          showModalBottomSheet<void>(
                                            context: context,
                                            backgroundColor: Colors.transparent,
                                            builder: (_) {
                                              return BlocProvider.value(
                                                value: context
                                                    .read<EventExpensesBloc>(),
                                                child: ExpensesImagePickerModal(
                                                  expenseId: expense.id,
                                                  isEditingExpense:
                                                      expense.proof != null,
                                                ),
                                              );
                                            },
                                          );
                                          break;
                                        case ExpenseAction.seeProof:
                                          showDialog(
                                              context: context,
                                              builder: (_) {
                                                return Dialog(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24),
                                                    child: Stack(
                                                      children: [
                                                        PhotoView(
                                                          initialScale:
                                                              PhotoViewComputedScale
                                                                  .contained,
                                                          imageProvider:
                                                              CachedNetworkImageProvider(
                                                            expense.proof!,
                                                            cacheKey:
                                                                'expense_${expense.id}',
                                                          ),
                                                          loadingBuilder:
                                                              (context, event) {
                                                            return Center(
                                                              child: Container(
                                                                color: Colors
                                                                    .black,
                                                                child:
                                                                    const Center(
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return Container(
                                                              color:
                                                                  Colors.black,
                                                              child:
                                                                  const Center(
                                                                child: Text(
                                                                  'Une erreur est survenue lors du chargement de l\'image',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          maxScale:
                                                              PhotoViewComputedScale
                                                                      .covered *
                                                                  2.0,
                                                          minScale:
                                                              PhotoViewComputedScale
                                                                  .contained,
                                                        ),
                                                        Positioned(
                                                          top: 16,
                                                          right: 16,
                                                          child: IconButton(
                                                            icon: const Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                          break;
                                      }
                                    },
                                    itemBuilder: (context) {
                                      return _buildExpenseActions(expense);
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

  List<PopupMenuItem> _buildExpenseActions(EventExpense expense) {
    final actions = <PopupMenuItem>[];

    if (expense.proof != null) {
      actions.add(
        const PopupMenuItem(
          value: ExpenseAction.seeProof,
          child: Row(
            children: [
              Icon(Icons.photo_album_rounded),
              SizedBox(width: 8),
              Text('Voir la preuve de paiement'),
            ],
          ),
        ),
      );
    }

    actions.addAll([
      PopupMenuItem(
        value: ExpenseAction.addProof,
        child: Row(
          children: [
            const Icon(Icons.photo_album_rounded),
            const SizedBox(width: 8),
            Text(
              expense.proof == null
                  ? 'Ajouter une preuve de paiement'
                  : 'Modifier la preuve de paiement',
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
    ]);

    return actions;
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
}
