import 'package:flutter/material.dart';

class LoadingBackground extends StatefulWidget {
  const LoadingBackground({super.key});

  @override
  State<LoadingBackground> createState() => _LoadingBackgroundState();
}

class _LoadingBackgroundState extends State<LoadingBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 5),
    vsync: this,
  )..repeat();

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.5, 0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  ));

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.3,
      widthFactor: 11,
      alignment: Alignment.centerRight,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Image.asset(
          "images/wallpaper.jpg",
          fit: BoxFit.fitHeight,
          repeat: ImageRepeat.repeatX,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
