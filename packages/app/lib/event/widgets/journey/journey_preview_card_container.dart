import 'package:flutter/material.dart';

class JourneyPreviewCardContainer extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;

  const JourneyPreviewCardContainer({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: child,
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}
