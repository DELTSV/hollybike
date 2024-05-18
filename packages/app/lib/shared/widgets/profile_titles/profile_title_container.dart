import 'package:flutter/material.dart';
import 'package:hollybike/shared/utils/add_separators.dart';

class ProfileTitleContainer extends StatelessWidget {
  final List<Widget> children;

  const ProfileTitleContainer({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: addSeparators(
        children,
        const SizedBox(
          height: 4,
        ),
      ),
    );
  }
}
