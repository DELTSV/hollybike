import 'package:flutter/material.dart';

class EventDetailsTabScrollWrapper extends StatelessWidget {
  final String scrollViewKey;
  final Widget child;
  final bool sliverChild;

  const EventDetailsTabScrollWrapper({
    super.key,
    required this.child,
    required this.scrollViewKey,
    this.sliverChild = false,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return CustomScrollView(
          key: PageStorageKey<String>(scrollViewKey),
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            _buildChild(),
          ],
        );
      },
    );
  }

  Widget _buildChild() {
    return sliverChild
        ? child
        : SliverToBoxAdapter(
            child: child,
          );
  }
}
