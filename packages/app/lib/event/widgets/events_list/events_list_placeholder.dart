import 'package:flutter/material.dart';

class ScrollablePlaceholder extends StatelessWidget {
  final Widget child;
  final double padding;
  final ScrollPhysics physics;

  const ScrollablePlaceholder({
    super.key,
    required this.child,
    required this.padding,
    this.physics = const BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    ),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        physics: physics,
        child: SizedBox(
          height: constraints.biggest.height,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: padding,
            ),
            child: Center(
              child: child,
            ),
          ),
        ),
      );
    });
  }
}
