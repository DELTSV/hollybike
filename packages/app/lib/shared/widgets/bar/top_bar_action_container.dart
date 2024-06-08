import 'package:flutter/material.dart';

class TopBarActionContainer extends StatefulWidget {
  final void Function()? onPressed;
  final Widget? child;

  const TopBarActionContainer({
    super.key,
    this.onPressed,
    required this.child,
  });

  @override
  State<TopBarActionContainer> createState() => _TopBarActionContainerState();
}

class _TopBarActionContainerState extends State<TopBarActionContainer>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Material(
        type: MaterialType.transparency,
        child: Ink(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary,
            border: Border.all(
              width: 2,
              color: Theme.of(context).colorScheme.onPrimary.withAlpha(100),
            ),
          ),
          child: InkWell(
            onTap: widget.onPressed,
            child: widget.child,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceOut);

    _controller.forward();
  }
}
