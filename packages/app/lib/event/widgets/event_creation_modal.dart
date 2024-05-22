import 'package:flutter/material.dart';
import 'package:hollybike/event/widgets/event_discard_changes_dialog.dart';

import 'event_form.dart';

class EventCreationModal extends StatelessWidget {
  final ScrollController _controller = ScrollController();

  EventCreationModal({super.key});

  @override
  Widget build(BuildContext context) {
    final border = BorderSide(
      color: Theme.of(context).colorScheme.onPrimary,
      width: 3,
    );

    return PopScope(
      canPop: false,
      onPopInvoked: (canPop) {
        if (canPop) return;
        showEventDiscardChangesDialog(context, () {
          Navigator.of(context).pop();
        });
      },
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          border: Border(
            top: border,
            left: border,
            right: border,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(31),
            topRight: Radius.circular(31),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 18,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => {
                      showEventDiscardChangesDialog(context, () {
                        Navigator.of(context).pop();
                      }),
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Créer"),
                  )
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _controller,
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 15,
                      top: 12,
                    ),
                    child: EventForm(
                      scrollToBottom: () {
                        _controller.animateTo(
                          _controller.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
