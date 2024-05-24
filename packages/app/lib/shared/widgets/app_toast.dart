import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_animations/simple_animations.dart';

class Toast {
  static Timer? toastTimer;
  static OverlayEntry? _overlayEntry;

  static void showCustomToast(
      BuildContext context, String message, Widget icon) {
    if (toastTimer == null || !toastTimer!.isActive) {
      _overlayEntry = createOverlayEntry(context, message, 2000, icon);
      Overlay.of(context).insert(_overlayEntry!);
      toastTimer = Timer(const Duration(milliseconds: 2500), () {
        if (_overlayEntry != null) {
          _overlayEntry!.remove();
        }
      });
    }
  }

  static void showSuccessToast(BuildContext context, String message) {
    showCustomToast(
      context,
      message,
      Lottie.asset(
        'assets/lottie/lottie_success_animation.json',
        width: 30,
        height: 30,
        repeat: false,
      ),
    );
  }

  static void showErrorToast(BuildContext context, String message) {
    showCustomToast(
      context,
      message,
      const Icon(
        Icons.error,
        color: Colors.red,
        size: 30,
      )
    );
  }

  static OverlayEntry createOverlayEntry(
      BuildContext context, String message, int toastDuration, Widget icon,
      [int animationDuration = 250]) {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ToastMessageAnimation(
              toastDuration: toastDuration,
              animationDuration: animationDuration,
              Material(
                elevation: 10.0,
                borderRadius: BorderRadius.circular(20),
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      icon,
                      const SizedBox(width: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Flexible(
                          child: Text(
                            message,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ToastMessageAnimation extends StatelessWidget {
  final Widget child;
  final int animationDuration;
  final int toastDuration;

  const ToastMessageAnimation(
    this.child, {
    super.key,
    required this.animationDuration,
    required this.toastDuration,
  });

  @override
  Widget build(BuildContext context) {
    final updatedTween = MovieTween()
      ..scene(
              begin: const Duration(milliseconds: 0),
              end: Duration(milliseconds: animationDuration))
          .tween(
            'translateY',
            Tween(begin: -100.0, end: 0.0),
            curve: Curves.easeOut,
          )
          .tween(
            'opacity',
            Tween(begin: 0.0, end: 1.0),
            curve: Curves.easeOut,
          )
      ..scene(
              begin: Duration(milliseconds: animationDuration),
              end: Duration(milliseconds: animationDuration + toastDuration))
          .tween(
            'translateY',
            Tween(begin: 0.0, end: 0.0),
          )
          .tween(
            'opacity',
            Tween(begin: 1.0, end: 1.0),
          )
      ..scene(
        begin: Duration(milliseconds: animationDuration + toastDuration),
        end: Duration(milliseconds: (animationDuration * 2) + toastDuration),
      )
          .tween(
            'translateY',
            Tween(begin: 0.0, end: -100.0),
            curve: Curves.easeIn,
          )
          .tween(
            'opacity',
            Tween(begin: 1.0, end: 0.0),
            curve: Curves.easeIn,
          );

    return PlayAnimationBuilder<Movie>(
      duration: updatedTween.duration,
      tween: updatedTween,
      child: child,
      builder: (context, animation, child) => Opacity(
        opacity: animation.get("opacity"),
        child: Transform.translate(
          offset: Offset(0, animation.get("translateY")),
          child: child,
        ),
      ),
    );
  }
}
