import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/event/widgets/journey/empty_journey_preview_card.dart';
import 'package:hollybike/event/widgets/journey/journey_preview_card_content.dart';

import '../../../journey/type/minimal_journey.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../bloc/event_journey_bloc/event_journey_bloc.dart';
import '../../bloc/event_journey_bloc/event_journey_state.dart';
import 'journey_preview_card_container.dart';

class JourneyPreviewCard extends StatelessWidget {
  final Event event;
  final MinimalJourney? journey;
  final bool canAddJourney;

  const JourneyPreviewCard({
    super.key,
    required this.journey,
    required this.event,
    required this.canAddJourney,
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
              state is EventJourneyGetPositionsInProgress,
            ),
          );
        },
      ),
    );
  }

  Widget _buildJourneyPreview(bool loadingPositions) {
    if (journey == null) {
      if (!canAddJourney) {
        return const SizedBox();
      }

      return EmptyJourneyPreviewCard(
        event: event,
      );
    }

    return JourneyPreviewCardContainer(
      onTap: () {

      },
      child: JourneyPreviewCardContent(
        journey: journey!,
        loadingPositions: loadingPositions,
      ),
    );
  }
}
