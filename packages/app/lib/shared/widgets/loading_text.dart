import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/loading_gradient.dart';

class LoadingText extends StatelessWidget {
  final TextStyle? textStyle;
  final int minLetters;
  final int maxLetters;

  const LoadingText({
    super.key,
    this.textStyle,
    required this.minLetters,
    required this.maxLetters,
  });

  @override
  Widget build(BuildContext context) {
    final numberOfLetters = minLetters + (Random()).nextInt(maxLetters - minLetters);
    final string = List.filled(numberOfLetters, "  ").join();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      clipBehavior: Clip.hardEdge,
      child: LoadingGradient(
        child: Text(
          string,
          style: textStyle,
        ),
      ),
    );
  }
}
