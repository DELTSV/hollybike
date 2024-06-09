import 'package:flutter/material.dart';

class AddPhotoSelectedImage extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;

  const AddPhotoSelectedImage({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: child,
      ),
      Positioned.fill(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            onTap: onTap,
          ),
        ),
      ),
    ]);
  }
}