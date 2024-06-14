import 'package:flutter/material.dart';

class SwitchWithText extends StatelessWidget {
  final void Function() onChange;
  final String text;
  final bool value;

  const SwitchWithText({
    super.key,
    required this.onChange,
    required this.text,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onChange,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Switch(
            value: value,
            activeColor: Theme.of(context).colorScheme.onPrimary,
            inactiveTrackColor: Theme.of(context).colorScheme.primaryContainer,
            trackOutlineColor: WidgetStateProperty.all(Theme.of(context)
                .colorScheme
                .primaryContainer
                .withOpacity(0.5)),
            inactiveThumbColor: Theme.of(context).colorScheme.primary,
            onChanged: (value) {
              onChange();
            },
          ),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }
}
