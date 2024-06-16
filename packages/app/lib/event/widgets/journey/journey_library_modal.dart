import 'package:flutter/material.dart';
import 'package:hollybike/event/widgets/journey/journey_library.dart';

class JourneyLibraryModal extends StatelessWidget {
  const JourneyLibraryModal({super.key});

  @override
  Widget build(BuildContext context) {
    final border = BorderSide(
      color: Theme.of(context).colorScheme.onPrimary,
      width: 3,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
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
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Selectionnez un parcours',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Flexible(
                      child: JourneyLibrary(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
