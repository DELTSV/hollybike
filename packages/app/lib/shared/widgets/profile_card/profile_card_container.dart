import 'package:flutter/material.dart';

class ProfileCardContainer extends StatelessWidget {
  final Widget profilePicture;
  final Widget profileTitle;
  final Widget? endChild;
  final void Function()? onTap;
  final bool? clickable;

  const ProfileCardContainer({
    super.key,
    required this.profilePicture,
    required this.profileTitle,
    this.endChild,
    this.onTap,
    this.clickable,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: onTap != null || clickable == true
            ? Theme.of(context).colorScheme.surface
            : Colors.transparent,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    profilePicture,
                    const SizedBox(width: 16),
                    profileTitle,
                  ],
                ),
              ] +
              (endChild != null ? [endChild as Widget] : []),
        ),
      ),
    );
  }
}