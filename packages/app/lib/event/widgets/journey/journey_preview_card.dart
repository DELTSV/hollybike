import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/widgets/journey/empty_journey_preview_card.dart';
import 'package:hollybike/event/widgets/journey/journey_modal.dart';
import 'package:hollybike/event/widgets/journey/journey_preview_card_content.dart';
import 'package:hollybike/event/widgets/journey/upload_journey_menu.dart';

import '../../../journey/type/minimal_journey.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../bloc/event_journey_bloc/event_journey_bloc.dart';
import '../../bloc/event_journey_bloc/event_journey_state.dart';
import 'journey_import_modal_from_type.dart';
import 'journey_preview_card_container.dart';

class JourneyPreviewCard extends StatelessWidget {
  final EventDetails eventDetails;
  final MinimalJourney? journey;
  final bool canAddJourney;
  final void Function() onViewOnMap;

  const JourneyPreviewCard({
    super.key,
    required this.journey,
    required this.eventDetails,
    required this.canAddJourney,
    required this.onViewOnMap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventJourneyBloc, EventJourneyState>(
      listener: (context, state) {
        if (state is EventJourneyOperationSuccess) {
          Toast.showSuccessToast(context, state.successMessage);
        }

        if (state is EventJourneyOperationFailure) {
          Toast.showErrorToast(context, state.errorMessage);
        }
      },
      child: BlocBuilder<EventJourneyBloc, EventJourneyState>(
        builder: (context, state) {
          return SizedBox(
            height: 140,
            child: _buildJourneyPreview(
              context,
              state is EventJourneyGetPositionsInProgress,
              state is EventJourneyOperationInProgress,
            ),
          );
        },
      ),
    );
  }

  Widget _buildJourneyPreview(
    BuildContext context,
    bool loadingPositions,
    bool loadingOperation,
  ) {
    if (journey == null && !loadingOperation) {
      if (!canAddJourney) {
        return const SizedBox();
      }

      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: UploadJourneyMenu(
          event: eventDetails.event,
          onSelection: (type) {
            journeyImportModalFromType(context, type, eventDetails.event);
          },
          child: EmptyJourneyPreviewCard(
            event: eventDetails.event,
          ),
        ),
      );
    }

    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 500),
      crossFadeState: loadingOperation
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      firstChild: SizedBox(
        height: 140,
        child: JourneyPreviewCardContainer(
          onTap: () {
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              context: context,
              builder: (context) => JourneyModal(
                journey: journey!,
                eventDetails: eventDetails,
                onViewOnMap: onViewOnMap,
              ),
            );
          },
          child: JourneyPreviewCardContent(
            journey: journey,
            loadingPositions: loadingPositions,
          ),
        ),
      ),
      secondChild: SizedBox(
        height: 140,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
