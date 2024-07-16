/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/widgets/expenses/currency_input.dart';

class EditBudgetModal extends StatefulWidget {
  final bool addMode;
  final int? budget;

  final void Function(
    int budget,
  ) onBudgetChange;

  const EditBudgetModal({
    super.key,
    required this.onBudgetChange,
    this.addMode = false,
    this.budget,
  });

  @override
  State<EditBudgetModal> createState() => _EditBudgetModalState();
}

class _EditBudgetModalState extends State<EditBudgetModal> {
  late final TextEditingController _budgetController;

  @override
  void initState() {
    _budgetController = TextEditingController(
      text: _getDefaultBudget(),
    );
    super.initState();
  }

  String _getDefaultBudget() {
    if (widget.addMode) {
      return '';
    }

    if (widget.budget == null) {
      return '';
    }

    final correctedBudget = widget.budget! * 100;

    return CurrencyInputFormatter.defaultFormat(correctedBudget.toString());
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        widget.addMode ? 'Ajouter un budget' : 'Modifier le budget',
      ),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CurrencyInput(
              controller: _budgetController,
              labelText: 'Budget',
              validator: (value) {
                if (value?.isEmpty == true || value == '0,00 €') {
                  return 'Veuillez entrer un budget';
                }

                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) {
              return;
            }

            final budget = int.parse(
              _budgetController.text.replaceAll(RegExp(r'[^0-9]'), ''),
            );

            widget.onBudgetChange(
              (budget / 100).round(),
            );

            Navigator.of(context).pop();
          },
          child: Text(widget.addMode ? 'Ajouter' : 'Modifier'),
        ),
      ],
    );
  }
}
