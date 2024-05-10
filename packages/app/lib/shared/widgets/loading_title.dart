import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/app_title.dart';

class LoadingTitle extends StatelessWidget {
  const LoadingTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final border = BorderSide(
      width: 6,
      color: Theme.of(context).colorScheme.onPrimary,
    );

    return FractionallySizedBox(
      heightFactor: 0.3,
      widthFactor: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border(top: border, bottom: border),
        ),
        padding: const EdgeInsets.all(32),
        child: const FittedBox(
          child: AppTitle(
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}
