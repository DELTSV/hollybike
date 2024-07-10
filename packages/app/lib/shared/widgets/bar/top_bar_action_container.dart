import 'package:flutter/material.dart';

class TopBarActionContainer extends StatefulWidget {
  final void Function()? onPressed;
  final Widget? child;
  final bool colorInverted;

  const TopBarActionContainer({
    super.key,
    this.onPressed,
    required this.child,
    this.colorInverted = false,
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
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.colorInverted
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.primary,
          ),
          child: Material(
            shape: const CircleBorder(),
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: widget.onPressed,
              child: widget.child,
            ),
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
