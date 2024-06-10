import 'package:flutter/material.dart';

class AddPhotoImageContainer extends StatefulWidget {
  final Widget child;
  final void Function()? onTap;
  final bool isSelected;

  const AddPhotoImageContainer({
    super.key,
    required this.child,
    this.onTap,
    required this.isSelected,
  });

  @override
  State<AddPhotoImageContainer> createState() => _AddPhotoImageContainerState();
}

class _AddPhotoImageContainerState extends State<AddPhotoImageContainer> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      AnimatedScale(
        curve: Curves.easeInOut,
        scale: widget.isSelected ? 0.88 : 1,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Colors.transparent,
              width: 1,
            ),
          ),
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: widget.child,
          ),
        ),
      ),

      Positioned(
        right: 0,
        child: AnimatedScale(
          scale: widget.isSelected ? 1 : 0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 4,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(2),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 10,
              ),
            ),
          ),
        ),
      ),
      Positioned.fill(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onTap: widget.onTap,
          ),
        ),
      ),
    ]);
  }
}
