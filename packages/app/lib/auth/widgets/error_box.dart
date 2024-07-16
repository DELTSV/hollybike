/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

class ErrorBox extends StatelessWidget {
  final String error;
  final void Function() onCloseButtonClick;

  const ErrorBox({
    super.key,
    required this.error,
    required this.onCloseButtonClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 4,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              error,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontVariations: const [FontVariation.weight(700)],
              ),
            ),
          ),
          IconButton(
            onPressed: onCloseButtonClick,
            color: Theme.of(context).colorScheme.error,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
