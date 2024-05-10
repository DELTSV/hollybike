import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/loading_gradient.dart';

class LoadingProfilePicture extends StatelessWidget {
  const LoadingProfilePicture({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tight(const Size.square(40)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.hardEdge,
      child: const LoadingGradient(),
    );
  }
}
