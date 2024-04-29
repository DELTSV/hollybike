import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  final double? fontSize;
  final String title = "HOLLYBIKE";

  const AppTitle({super.key, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          title,
          style: TextStyle(
            fontVariations: const [
              FontVariation.slant(-10),
              FontVariation.weight(800),
            ],
            fontSize: fontSize,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 6
              ..color = Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontVariations: const [
              FontVariation.slant(-10),
              FontVariation.weight(800),
            ],
            fontSize: fontSize,
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
      ],
    );
  }
}
