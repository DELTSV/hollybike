import 'package:flutter/material.dart';

import 'add_photos_modal.dart';

class AddPhotosFloatingButton extends StatelessWidget {
  const AddPhotosFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return AddPhotosModal(
              onClose: () {
                Navigator.of(context).pop();
              },
              onSubmit: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      },
      label: const Text("Ajouter des photos"),
      icon: const Icon(Icons.add_a_photo),
    );
  }
}
