import 'package:flutter/material.dart';

import '../../shared/types/position.dart';

class JourneyPosition extends StatelessWidget {
  final Position? pos;

  const JourneyPosition({
    super.key,
    required this.pos,
  });

  @override
  Widget build(BuildContext context) {
    if (pos == null) {
      return const SizedBox();
    }

    final texts = <TextSpan>[];

    void addSpan(TextSpan span) {
      if (texts.isNotEmpty) {
        texts.add(
          TextSpan(
            text: ", ",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        );
      }

      texts.add(span);
    }

    final countyName = pos?.countyName;
    final cityName = pos?.cityName;
    final countryName = pos?.countryName;

    if (cityName != null) {
      addSpan(TextSpan(
        text: cityName,
        style: Theme.of(context).textTheme.bodySmall,
      ));
    }

    if (countyName != null) {
      addSpan(TextSpan(
        text: countyName,
        style: Theme.of(context).textTheme.bodySmall,
      ));
    }

    if (countryName != null && countryName != "France") {
      addSpan(TextSpan(
        text: countryName,
        style: Theme.of(context).textTheme.bodySmall,
      ));
    }

    if (texts.isEmpty) {
      return const SizedBox();
    }

    return RichText(
      softWrap: true,
      text: TextSpan(
        children: texts,
      ),
    );
  }
}
