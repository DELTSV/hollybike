import 'package:flutter/material.dart';

enum SwitchAlignment { left, right }

class SwitchWithText extends StatelessWidget {
  final void Function()? onChange;
  final String text;
  final bool value;
  final SwitchAlignment alignment;

  const SwitchWithText({
    super.key,
    required this.onChange,
    required this.text,
    required this.value,
    this.alignment = SwitchAlignment.left,
  });

  @override
  Widget build(BuildContext context) {
    final switchWidget = Switch(
      value: value,
      onChanged: onChange != null
          ? (value) {
              onChange?.call();
            }
          : null,
    );

    const separator = SizedBox(width: 10);

    final label = Expanded(
      child: Text(
        text,
        softWrap: true,
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onChange,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: alignment == SwitchAlignment.left
            ? [switchWidget, separator, label]
            : [label, separator, switchWidget],
      ),
    );
  }
}
