import 'package:flutter/material.dart';

class ImagePickerModalHeader extends StatelessWidget {
  final void Function() onClose;
  final void Function() onSubmit;
  final bool canSubmit;

  const ImagePickerModalHeader({
    super.key,
    required this.onClose,
    required this.onSubmit,
    required this.canSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: onClose,
        ),
        ElevatedButton(
          onPressed: canSubmit ? onSubmit : null,
          child: const Text("Ajouter"),
        )
      ],
    );
  }
}
