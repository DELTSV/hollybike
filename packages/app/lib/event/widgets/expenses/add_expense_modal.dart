import 'package:flutter/material.dart';
import 'package:hollybike/event/widgets/expenses/currency_input.dart';
import 'package:hollybike/shared/widgets/text_field/common_text_field.dart';

class AddExpenseModal extends StatefulWidget {
  final void Function(
    String name,
    int amount,
    String? description,
  ) onAddExpense;

  const AddExpenseModal({super.key, required this.onAddExpense});

  @override
  State<AddExpenseModal> createState() => _AddExpenseModalState();
}

class _AddExpenseModalState extends State<AddExpenseModal> {
  late final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _amountController = TextEditingController();
  late final TextEditingController _descriptionController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: const Text(
        'Ajouter une dépense',
      ),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonTextField(
              controller: _nameController,
              title: 'Nom',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value?.isEmpty == true) {
                  return 'Veuillez entrer un nom';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),
            CurrencyInput(
              controller: _amountController,
              labelText: 'Montant',
              validator: (value) {
                if (value?.isEmpty == true || value == '0,00 €') {
                  return 'Veuillez entrer un montant';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),
            CommonTextField(
              controller: _descriptionController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              title: 'Description (optionnel)',
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

            final name = _nameController.text;
            final amount = int.parse(
              _amountController.text.replaceAll(RegExp(r'[^0-9]'), ''),
            );

            final description = _descriptionController.text.isNotEmpty
                ? _descriptionController.text
                : null;

            widget.onAddExpense(name, amount, description);

            Navigator.of(context).pop();
          },
          child: const Text('Ajouter'),
        ),
      ],
    );
  }
}
