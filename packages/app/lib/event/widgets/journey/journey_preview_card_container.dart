import 'package:flutter/material.dart';

class JourneyPreviewCardContainer extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;
  final bool loading;

  const JourneyPreviewCardContainer({
    super.key,
    required this.child,
    required this.loading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 500),
        crossFadeState:
            loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        firstChild: Stack(
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
        ),
        secondChild: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
