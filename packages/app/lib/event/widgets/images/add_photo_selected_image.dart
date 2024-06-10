import 'package:flutter/material.dart';

class AddPhotoSelectedImage extends StatefulWidget {
  final Widget child;
  final void Function()? onDelete;

  const AddPhotoSelectedImage({
    super.key,
    required this.child,
    this.onDelete,
  });

  @override
  State<AddPhotoSelectedImage> createState() => _AddPhotoSelectedImageState();
}

class _AddPhotoSelectedImageState extends State<AddPhotoSelectedImage> {
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
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 4,
                  ),
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
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
