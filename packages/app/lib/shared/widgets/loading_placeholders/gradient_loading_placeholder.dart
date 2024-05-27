import 'package:flutter/material.dart';

class GradientLoadingPlaceholder extends StatefulWidget {
  final Widget? child;

  const GradientLoadingPlaceholder({super.key, this.child});

  @override
  State<GradientLoadingPlaceholder> createState() =>
      _GradientLoadingPlaceholderState();
}

class _GradientLoadingPlaceholderState extends State<GradientLoadingPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _beginAlignment;
  late Animation<Alignment> _endAlignment;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _beginAlignment = TweenSequence<Alignment>([
      TweenSequenceItem<Alignment>(
        tween: Tween<Alignment>(
          begin: const Alignment(-3, -3),
          end: const Alignment(1, 1),
        ),
        weight: 1,
      ),
    ]).animate(_controller);

    _endAlignment = TweenSequence<Alignment>([
      TweenSequenceItem<Alignment>(
        tween: Tween<Alignment>(
          begin: const Alignment(-1, -1),
          end: const Alignment(3, 3),
        ),
        weight: 1,
      ),
    ]).animate(_controller);

    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Container(
            constraints:
                widget.child == null ? const BoxConstraints.expand() : null,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: _beginAlignment.value,
                end: _endAlignment.value,
                colors: const [
                  Color(0x20b4befe),
                  Color(0x40b4befe),
                  Color(0x20b4befe),
                ],
              ),
            ),
            child: widget.child,
          );
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
