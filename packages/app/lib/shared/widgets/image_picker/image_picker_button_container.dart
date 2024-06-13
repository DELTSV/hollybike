import 'package:flutter/material.dart';

class ImagePickerButtonContainer extends StatelessWidget {
  final Icon icon;
  final void Function()? onTap;

  const ImagePickerButtonContainer({
    super.key,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Theme.of(context).primaryColor,
          child: Center(
            child: icon,
          ),
        ),
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
