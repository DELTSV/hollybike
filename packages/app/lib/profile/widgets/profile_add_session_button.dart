import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/app/app_router.gr.dart';

class ProfileAddSessionButton extends StatelessWidget {
  const ProfileAddSessionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: double.infinity),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(16),
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        onPressed: () {
          context.router.push(
            LoginRoute(
              onAuthSuccess: () => context.router.maybePop(),
              canPop: true,
            ),
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.add),
            SizedBox(width: 8),
            Text(
              "Ajouter un compte",
              style: TextStyle(
                fontVariations: [FontVariation.weight(700)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
