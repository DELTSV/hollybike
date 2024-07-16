/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
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
        child: SizedBox(
          height: 46,
          child: Stack(
            fit: StackFit.expand,
            children: _renderTitle() +
                [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _renderFix(prefix) + _renderFix(suffix),
                  ),
                ],
          ),
        ),
      ),
    );
  }

  List<Widget> _renderFix(Widget? fix) => fix == null
      ? [const SizedBox()]
      : [
          SizedBox(
            height: double.infinity,
            child: fix,
          )
        ];

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
                      child: title,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ];
}
