import 'package:flutter/material.dart';

class ImagePickerSelectedImage extends StatefulWidget {
  final Widget child;
  final void Function()? onDelete;

  const ImagePickerSelectedImage({
    super.key,
    required this.child,
    this.onDelete,
  });

  @override
  State<ImagePickerSelectedImage> createState() =>
      _ImagePickerSelectedImageState();
}

class _ImagePickerSelectedImageState extends State<ImagePickerSelectedImage> {
  bool initial = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        initial = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      AnimatedScale(
        curve: Curves.easeInOut,
        scale: initial ? 1 : 0.88,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
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
          scale: initial ? 0 : 1,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(3),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                        size: 16,
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
                      borderRadius: BorderRadius.circular(30),
                    ),
                    onTap: widget.onDelete,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
