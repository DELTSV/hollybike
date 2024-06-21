import 'package:flutter/material.dart';
import 'package:hollybike/shared/utils/add_separators.dart';

class SearchInitialPlaceholder extends StatelessWidget {
  final void Function() onButtonTap;

  const SearchInitialPlaceholder({super.key, required this.onButtonTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: addSeparators(
          [
            const Text(
              "Cherchez des évènement ou d'autres utilisateurs par leur nom",
            ),
            ElevatedButton(
              onPressed: onButtonTap,
              child: const Text("Commencer votre recherche"),
            )
          ],
          const SizedBox.square(
            dimension: 16,
          ),
        ),
      ),
    );
  }
}
