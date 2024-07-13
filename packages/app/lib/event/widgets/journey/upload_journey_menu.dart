import 'package:flutter/material.dart';
import '../../types/event.dart';

enum NewJourneyType {
  library,
  file,
  userJourney,
  external,
}

Future<NewJourneyType?> showUploadJourneyMenu(BuildContext context,
    {bool includeLibrary = true, required RelativeRect position}) async {
  final value = await showMenu(
    context: context,
    position: position,
    items: [
      if (includeLibrary)
        const PopupMenuItem(
          value: NewJourneyType.library,
          child: Text('Depuis un parcours existant'),
        ),
      const PopupMenuItem(
        value: NewJourneyType.userJourney,
        child: Text('Depuis un trajet précédent'),
      ),
      const PopupMenuItem(
        value: NewJourneyType.external,
        child: Text('Depuis un outil externe'),
      ),
      const PopupMenuItem(
        value: NewJourneyType.file,
        child: Text('Depuis un fichier GPX/GEOJSON'),
      ),
    ],
  );

  return value;
}

class UploadJourneyMenu extends StatelessWidget {
  final Event event;
  final bool includeLibrary;
  final Widget child;
  final void Function(NewJourneyType)? onSelection;

  const UploadJourneyMenu({
    super.key,
    required this.event,
    required this.child,
    this.onSelection,
    this.includeLibrary = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTapDown: (details) async {
                final value = await showUploadJourneyMenu(
                  context,
                  includeLibrary: includeLibrary,
                  position: RelativeRect.fromLTRB(
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                  ),
                );

                if (value != null) {
                  onSelection?.call(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
