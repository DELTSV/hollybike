import 'package:flutter/material.dart';
import '../../types/event.dart';

enum NewJourneyType {
  library,
  file,
}

class UploadJourneyMenu extends StatelessWidget {
  final bool popBefore;
  final Event event;
  final bool noPadding;
  final Widget child;
  final void Function(NewJourneyType)? onSelection;

  const UploadJourneyMenu({
    super.key,
    this.popBefore = false,
    this.noPadding = false,
    required this.event,
    required this.child,
    this.onSelection,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: noPadding ? EdgeInsets.zero : const EdgeInsets.all(12),
      icon: child,
      onSelected: onSelection,
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: NewJourneyType.library,
            child: Text('Depuis un parcours existant'),
          ),
          const PopupMenuItem(
            value: NewJourneyType.file,
            child: Text('Importer un fichier GPX/GEOJSON'),
          ),
        ];
      },
    );
  }
}
