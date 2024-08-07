/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/loading_placeholders/text_loading_placeholder.dart';
import 'package:hollybike/shared/widgets/profile_titles/profile_title_container.dart';

class LoadingProfileTitle extends StatelessWidget {
  const LoadingProfileTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileTitleContainer(children: [
      TextLoadingPlaceholder(
        textStyle: Theme.of(context).textTheme.titleSmall,
        minLetters: 4,
        maxLetters: 12,
      ),
      TextLoadingPlaceholder(
        textStyle: Theme.of(context).textTheme.bodySmall,
        minLetters: 13,
        maxLetters: 25,
      ),
    ]);
  }
}
