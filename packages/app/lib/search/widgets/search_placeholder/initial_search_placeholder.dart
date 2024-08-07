/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class InitialSearchPlaceholder extends StatelessWidget {
  final void Function() onButtonTap;

  const InitialSearchPlaceholder({super.key, required this.onButtonTap});

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
              'assets/lottie/lottie_search_initial_placeholder.json',
              repeat: false,
              height: 150,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Text(
                "Cherchez des évènement ou d'autres utilisateurs par leur nom",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox.square(dimension: 20),
            ElevatedButton(
              onPressed: onButtonTap,
              child: const Text("Commencer votre recherche"),
            )
          ],
        ),
      ),
    );
  }
}
