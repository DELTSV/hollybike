import 'package:flutter/material.dart';

class PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;
  final int? animationDuration;

  const PinnedHeaderDelegate({
    required this.child,
    required this.height,
    this.animationDuration,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Align(
      alignment: Alignment.topLeft,
      child: AnimatedCrossFade(
        firstChild: SizedBox(
          height: height,
          child: child,
        ),
        secondChild: SizedBox(
          height: height,
          child: child,
        ),
        crossFadeState: shrinkOffset > 0
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: Duration(milliseconds: animationDuration ?? 0),
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
