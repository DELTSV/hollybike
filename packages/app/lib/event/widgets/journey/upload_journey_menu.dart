import 'package:flutter/material.dart';

import '../../types/event.dart';

enum NewJourneyType {
  library,
  file,
}

class UploadJourneyMenu extends StatelessWidget {
  final Event event;
  final Widget child;
  final void Function(NewJourneyType)? onSelection;

  const UploadJourneyMenu({
    super.key,
    required this.event,
    required this.child,
    this.onSelection,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(onTapDown: (details) {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  details.globalPosition.dx,
                  details.globalPosition.dy,
                  details.globalPosition.dx,
                  details.globalPosition.dy,
                ),
                items: [
                  PopupMenuItem(
                    value: NewJourneyType.library,
                    child: const Text('Depuis un parcours existant'),
                    onTap: () {
                      onSelection?.call(NewJourneyType.library);
                    },
                  ),
                  PopupMenuItem(
                    value: NewJourneyType.file,
                    child: const Text('Importer un fichier GPX/GEOJSON'),
                    onTap: () {
                      onSelection?.call(NewJourneyType.file);
                    },
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
