/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

import '../../shared/types/position.dart';

class JourneyPosition extends StatelessWidget {
  final bool isLarge;
  final Position pos;

  const JourneyPosition({
    super.key,
    this.isLarge = false,
    required this.pos,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = getTextStyle(context);

    final texts = <TextSpan>[];

    void addSpan(TextSpan span) {
      if (texts.isNotEmpty) {
        texts.add(
          TextSpan(
            text: ", ",
            style: textStyle,
          ),
        );
      }

      texts.add(span);
    }

    final countyName = pos.countyName;
    final cityName = pos.cityName;
    final countryName = pos.countryName;

    if (cityName != null) {
      addSpan(TextSpan(
        text: cityName,
        style: textStyle,
      ));
    }

    if (countyName != null) {
      addSpan(TextSpan(
        text: countyName,
        style: textStyle,
      ));
    }

    if (countryName != null && countryName != "France") {
      addSpan(TextSpan(
        text: countryName,
        style: textStyle,
      ));
    }

    if (texts.isEmpty) {
      return const SizedBox();
    }

    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      text: TextSpan(
        children: texts,
      ),
    );
  }

  TextStyle? getTextStyle(BuildContext context) {
    return isLarge
        ? Theme.of(context).textTheme.titleSmall
        : Theme.of(context).textTheme.bodySmall;
  }
}
