import 'package:flutter/material.dart';
import 'package:hollybike/shared/utils/render_nullable_widget_to_list.dart';
import 'package:hollybike/shared/widgets/bar/bar_container.dart';

class TopBar extends StatelessWidget {
  final Widget? prefix;
  final Widget title;

  const TopBar({
    super.key,
    this.prefix,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: renderNullableWidgetToList(prefix) +
            [
              Expanded(
                child: BarContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: title,
                  ),
                ),
              ),
            ],
      ),
    );
  }
}
