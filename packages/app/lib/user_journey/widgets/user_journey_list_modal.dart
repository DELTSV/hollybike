import 'package:flutter/material.dart';
import 'package:hollybike/profile/widgets/profile_journeys.dart';
import 'package:hollybike/user/types/minimal_user.dart';

class UserJourneyListModal extends StatefulWidget {
  final void Function(String) fileSelected;
  final MinimalUser user;

  const UserJourneyListModal({
    super.key,
    required this.fileSelected,
    required this.user,
  });

  @override
  State<UserJourneyListModal> createState() => _UserJourneyListModalState();
}

class _UserJourneyListModalState extends State<UserJourneyListModal> {
  late final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(31),
          topRight: Radius.circular(31),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 0,
              ),
              child: Row(
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
                    'Selectionnez un trajet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            Flexible(
              child: ProfileJourneys(
                user: widget.user,
                isMe: true,
                scrollController: scrollController,
                isNested: false,
                onJourneySelected: (userJourney) {
                  widget.fileSelected(userJourney.file);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
