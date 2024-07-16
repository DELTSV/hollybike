/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/loading_placeholders/gradient_loading_placeholder.dart';
import 'package:hollybike/shared/widgets/loading_placeholders/text_loading_placeholder.dart';

class PlaceholderEventPreviewCard extends StatelessWidget {
  const PlaceholderEventPreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        height: 110,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 110,
              height: double.infinity,
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  const ClipRRect(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(10),
                    ),
                    child: GradientLoadingPlaceholder(),
                  ),
                  Container(
                    height: double.infinity,
                    width: 15,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.transparent,
                          Theme.of(context).colorScheme.primaryContainer,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LayoutBuilder(builder: (context, constraints) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextLoadingPlaceholder(
                        minLetters: 20,
                        maxLetters: 29,
                        textStyle: Theme.of(context).textTheme.titleMedium,
                      ),
                      const TextLoadingPlaceholder(
                        minLetters: 10,
                        maxLetters: 30,
                      )
                    ],
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
