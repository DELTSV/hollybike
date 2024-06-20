import 'package:flutter/material.dart';

class EventsListPlaceholder extends StatelessWidget {
  final Widget child;
  final double padding;

  const EventsListPlaceholder({
    super.key,
    required this.child,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
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
