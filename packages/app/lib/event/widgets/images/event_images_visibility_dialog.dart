import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/shared/utils/with_current_session.dart';
import 'package:hollybike/shared/widgets/dialog/closable_dialog.dart';
import 'package:hollybike/shared/widgets/switch_with_text.dart';

import '../../bloc/event_images_bloc/event_my_images_bloc.dart';
import '../../bloc/event_images_bloc/event_my_images_event.dart';

Future<void> showEventImagesVisibilityDialog(
  BuildContext context,
    {required bool isImagesPublic, required int eventId}
) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return EventImagesVisibilityDialog(
        isImagesPublic: isImagesPublic,
        eventId: eventId,
      );
    },
  );
}

class EventImagesVisibilityDialog extends StatefulWidget {
  final bool isImagesPublic;
  final int eventId;

  const EventImagesVisibilityDialog({
    super.key,
    required this.isImagesPublic,
    required this.eventId,
  });

  @override
  State<EventImagesVisibilityDialog> createState() =>
      _EventImagesVisibilityDialogState();
}

class _EventImagesVisibilityDialogState
    extends State<EventImagesVisibilityDialog> {
  late bool isPublic = widget.isImagesPublic;

  @override
  Widget build(BuildContext context) {
    return ClosableDialog(
      title: 'Visibilité de vos images',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Colors.transparent,
            child: SwitchWithText(
              value: isPublic,
              onChange: _onChanged,
              text: 'Rendre mes images publiques',
            ),
          ),
          const SizedBox(height: 15),
          _buildVisibilityHint(),
        ],
      ),
      onClose: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildVisibilityHint() {
    return isPublic
        ? const Text(
            'Vos images sont visibles par tous les membres de l\'assocation',
          )
        : const Text(
            'Seuls les participants de l\'événement peuvent voir vos images',
          );
  }

  void _onChanged() {
    setState(() {
      isPublic = !isPublic;
    });

    _updateImagesVisibility();
  }

  void _updateImagesVisibility() {
    withCurrentSession(context, (session) {
      BlocProvider.of<EventMyImagesBloc>(context).add(
        UpdateImagesVisibility(
          session: session,
          eventId: widget.eventId,
          isPublic: isPublic,
        ),
      );
    });
  }
}
