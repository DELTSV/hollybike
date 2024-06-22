import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptySearchPlaceholder extends StatelessWidget {
  final String? lastSearch;

  const EmptySearchPlaceholder({super.key, required this.lastSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: double.infinity),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              fit: BoxFit.cover,
              'assets/lottie/lottie_empty_data.json',
              height: 150,
            ),
            const SizedBox.square(dimension: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    const TextSpan(
                      text:
                          "Aucun évènement ou utilisateurs trouvé pour la recherche ",
                    ),
                    TextSpan(
                      text: '"$lastSearch"',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
