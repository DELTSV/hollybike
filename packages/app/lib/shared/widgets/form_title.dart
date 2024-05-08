import 'package:flutter/material.dart';

class FormTitle extends StatelessWidget {
  final String title;
  final String? description;

  const FormTitle({
    super.key,
    required this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    if (description == null) {
      return renderTitle(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        renderTitle(context),
        Text(
          description as String,
          style: Theme.of(context).textTheme.titleSmall,
        )
      ],
    );
  }

  Widget renderTitle(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}
