import 'package:flutter/material.dart';

class ShadowGradientStripe extends StatelessWidget {
  const ShadowGradientStripe({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(height: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface.withOpacity(0.5),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
