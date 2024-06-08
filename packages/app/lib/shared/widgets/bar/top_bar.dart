import 'package:flutter/material.dart';
import 'package:hollybike/shared/utils/render_nullable_widget_to_list.dart';
import 'package:hollybike/shared/widgets/bar/bar_container.dart';

class TopBar extends StatelessWidget {
  final Widget? prefix;
  final Widget? suffix;
  final Widget title;

  const TopBar({
    super.key,
    this.prefix,
    this.suffix,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: prefix == null ? 0 : 16,
          right: suffix == null ? 0 : 16,
        ),
        child: Stack(
          children: [
            AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.only(
                left: prefix == null ? 0 : 48,
                right: suffix == null ? 0 : 48,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Hero(
                      tag: "top_bar_title",
                      child: BarContainer(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: title,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              constraints: BoxConstraints.tight(const Size.fromHeight(90)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _renderFix(prefix) + _renderFix(suffix),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _renderFix(Widget? fix) =>
      fix == null ? [const SizedBox()] : [fix];
}
