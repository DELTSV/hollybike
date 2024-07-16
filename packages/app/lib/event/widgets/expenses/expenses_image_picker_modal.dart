/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_expenses_bloc/event_expenses_bloc.dart';
import 'package:hollybike/event/bloc/event_expenses_bloc/event_expenses_event.dart';
import 'package:hollybike/event/bloc/event_expenses_bloc/event_expenses_state.dart';
import 'package:hollybike/image/type/image_picker_mode.dart';
import 'package:hollybike/image/widgets/image_picker/image_picker_modal.dart';
import 'package:hollybike/shared/utils/safe_set_state.dart';

class ExpensesImagePickerModal extends StatefulWidget {
  final int expenseId;
  final bool isEditingExpense;

  const ExpensesImagePickerModal({
    super.key,
    required this.expenseId,
    required this.isEditingExpense,
  });

  @override
  State<ExpensesImagePickerModal> createState() =>
      _ExpensesImagePickerModalState();
}

class _ExpensesImagePickerModalState extends State<ExpensesImagePickerModal> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventExpensesBloc, EventExpensesState>(
      listener: (context, state) {
        if (state is EventExpensesOperationSuccess) {
          Navigator.of(context).pop();
        }

        if (state is EventExpensesOperationInProgress) {
          setState(() {
            _loading = true;
          });
        } else {
          Future.delayed(const Duration(milliseconds: 300), () {
            safeSetState(() {
              _loading = false;
            });
          });
        }
      },
      child: ImagePickerModal(
        isLoading: _loading,
        mode: ImagePickerMode.single,
        onClose: () {
          Navigator.of(context).pop();
        },
        onSubmit: (images) => onSubmit(context, images.first),
      ),
    );
  }

  void onSubmit(BuildContext context, File image) {
    context.read<EventExpensesBloc>().add(
          UploadExpenseProof(
            image: image,
            expenseId: widget.expenseId,
            successMessage: widget.isEditingExpense
                ? 'Preuve de paiment modifiée.'
                : 'Preuve de paiment ajoutée.',
          ),
        );
  }
}
