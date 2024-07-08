import 'package:flutter/material.dart';

class GradientProgressBar extends StatefulWidget {
  final double maxValue;
  final double value;
  final List<Color> colors;
  final bool animateStart;

  const GradientProgressBar({
    super.key,
    required this.maxValue,
    required this.value,
    required this.colors,
    required this.animateStart,
  });

  @override
  State<GradientProgressBar> createState() => _GradientProgressBarState();
}

class _GradientProgressBarState extends State<GradientProgressBar>
    with SingleTickerProviderStateMixin {
  late final _progressController = AnimationController(
    vsync: this,
  );

  @override
  void didUpdateWidget(GradientProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value ||
        oldWidget.maxValue != widget.maxValue) {
      _animate();
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (widget.animateStart) {
        _animate();
      } else {
        _progressController.value = getTargetFraction();
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _animate() {
    Future.delayed(const Duration(milliseconds: 200), () {
      _progressController.animateTo(
        getTargetFraction(),
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
      );
    });
  }

  double getTargetFraction() {
    final clampedValue = widget.value.clamp(0, widget.maxValue);
    return (clampedValue / widget.maxValue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
      ),
      child: AnimatedBuilder(
        animation: _progressController,
        builder: (context, child) {
          return FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _progressController.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _getInterpolatedColor(_progressController.value),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getInterpolatedColor(double fraction) {
    if (fraction <= 0) {
      return widget.colors.first;
    } else if (fraction >= 1) {
      return widget.colors.last;
    }

    // Find two colors to interpolate between
    for (int i = 0; i < widget.colors.length - 1; i++) {
      double stopStart = i / (widget.colors.length - 1);
      double stopEnd = (i + 1) / (widget.colors.length - 1);

      if (fraction >= stopStart && fraction <= stopEnd) {
        double localFraction = (fraction - stopStart) / (stopEnd - stopStart);
        return Color.lerp(
            widget.colors[i], widget.colors[i + 1], localFraction)!;
      }
    }

    return widget.colors.last;
  }
}
