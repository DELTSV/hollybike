import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class QrcodeCameraScreenshot extends StatelessWidget {
  final Uint8List img;
  final List<Offset> corners;
  final BoxConstraints constraints;

  const QrcodeCameraScreenshot({
    super.key,
    required this.img,
    required this.corners,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ConstrainedBox(
          constraints: constraints,
          child: Image.memory(
            img,
            fit: BoxFit.fitWidth,
          ),
        ),
        ConstrainedBox(
          constraints: constraints,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final topLeftCorner = corners.first;
              final bottomRightCorner = corners.elementAt(2);

              return Padding(
                padding: EdgeInsets.only(
                  top: max(
                    (constraints.biggest.height * (topLeftCorner.dy / 640)) -
                        20,
                    0,
                  ),
                  left: max(
                    (constraints.biggest.width * (topLeftCorner.dx / 480)) - 20,
                    0,
                  ),
                  bottom: max(
                    (constraints.biggest.height -
                            constraints.biggest.height *
                                (bottomRightCorner.dy / 640)) -
                        20,
                    0,
                  ),
                  right: max(
                    (constraints.biggest.width -
                            constraints.biggest.width *
                                (bottomRightCorner.dx / 480)) -
                        20,
                    0,
                  ),
                ),
                child: Container(
                  constraints: const BoxConstraints.expand(),
                  alignment: Alignment.center,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 3,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      constraints: const BoxConstraints.expand(),
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
