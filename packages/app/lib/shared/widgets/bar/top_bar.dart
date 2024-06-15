import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/bar/bar_container.dart';

class TopBar extends StatelessWidget {
  final Widget? prefix;
  final Widget? suffix;
  final Widget? title;
  final bool noPadding;

  const TopBar({
    super.key,
    this.prefix,
    this.suffix,
    this.title,
    this.noPadding = false,
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
          children: _renderTitle() +
              [
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

  List<Widget> _renderTitle() => title == null
      ? <Widget>[]
      : <Widget>[
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
                    transitionOnUserGestures: true,
                    child: BarContainer(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: noPadding ? 1.5 : 16,
                          horizontal: 16,
                        ),
                        child: title,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ];
}
