import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_expense.dart';

class ExpensesModal extends StatelessWidget {
  final List<EventExpense> expenses;
  final int? budget;

  const ExpensesModal({
    super.key,
    required this.expenses,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            height: 400,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.attach_money),
                                SizedBox(width: 8),
                                Text('Modifier le budget'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.download),
                                SizedBox(width: 8),
                                Text('Télécharger le fichier CSV'),
                              ],
                            ),
                          ),
                        ];
                      },
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Ajouter une dépense'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
