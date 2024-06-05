import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_participations_bloc/event_participations_bloc.dart';
import 'package:hollybike/event/bloc/event_participations_bloc/event_participations_event.dart';
import 'package:hollybike/event/bloc/event_participations_bloc/event_participations_state.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/types/event_participation.dart';
import 'package:hollybike/shared/widgets/hud/hud.dart';

import '../../shared/utils/with_current_session.dart';
import '../../shared/widgets/app_toast.dart';
import '../../shared/widgets/bar/top_bar.dart';
import '../../shared/widgets/bar/top_bar_prefix_button.dart';
import '../../shared/widgets/bar/top_bar_title.dart';
import '../widgets/participations/event_participation_card.dart';

@RoutePage()
class EventParticipationsScreen extends StatefulWidget {
  final EventDetails eventDetails;
  final List<EventParticipation> participationPreview;

  const EventParticipationsScreen({
    super.key,
    required this.eventDetails,
    required this.participationPreview,
  });

  @override
  State<EventParticipationsScreen> createState() =>
      _EventParticipationsScreenState();
}

class _EventParticipationsScreenState extends State<EventParticipationsScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _refreshParticipants();

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      var nextPageTrigger = 0.8 * _scrollController.position.maxScrollExtent;

      if (_scrollController.position.pixels > nextPageTrigger) {
        _loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventParticipationBloc, EventParticipationsState>(
      listener: (context, state) {
        if (state is EventParticipationsPageLoadFailure) {
          Toast.showErrorToast(context, state.errorMessage);
        } else if (state is EventParticipationsDeletionFailure) {
          Toast.showErrorToast(context, state.errorMessage);
        } else if (state is EventParticipationsOperationFailure) {
          Toast.showErrorToast(context, state.errorMessage);
        }

        if (state is EventParticipationsOperationSuccess) {
          Toast.showSuccessToast(context, state.successMessage);
        } else if (state is EventParticipationsDeleted) {
          Toast.showSuccessToast(context, "Participant retiré");
          // _refreshParticipants();
        }
      },
      child: Hud(
        appBar: TopBar(
          prefix: TopBarPrefixButton(
            onPressed: () => context.router.maybePop(),
            icon: Icons.arrow_back,
          ),
          title: const TopBarTitle("Participants"),
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () {
        //     showModalBottomSheet(
        //       context: context,
        //       isScrollControlled: true,
        //       builder: (context) {
        //         return FractionallySizedBox(
        //           heightFactor: 0.9,
        //           child: Container(),
        //         );
        //       },
        //     );
        //   },
        //   label: Text(
        //     'Ajouter',
        //     style: Theme.of(context).textTheme.titleSmall?.copyWith(
        //           color: Theme.of(context).colorScheme.primary,
        //         ),
        //   ),
        //   icon: const Icon(Icons.edit),
        // ),
        body: RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () async {
            _refreshParticipants();
          },
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child:
                  BlocBuilder<EventParticipationBloc, EventParticipationsState>(
                builder: (context, state) {
                  if (state is EventParticipationsPageLoadFailure) {
                    return Center(
                      child: Text(state.errorMessage),
                    );
                  }

                  return _buildList(state.participants);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<EventParticipation> participants) {
    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: participants.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      itemBuilder: (context, index) {
        final participation = participants[index];

        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 250),
          curve: Curves.ease,
          builder: (context, double value, child) {
            return Transform.translate(
              offset: Offset(30 * (1 - value), 0),
              child: Opacity(
                opacity: value,
                child: EventParticipationCard(
                  eventId: widget.eventDetails.event.id,
                  participation: participation,
                  isOwner: widget.eventDetails.event.owner.id ==
                      participation.user.id,
                  isCurrentUser: participation.user.id ==
                      widget.eventDetails.callerParticipation?.userId,
                  isCurrentUserOrganizer: widget.eventDetails.isOrganizer,
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _loadNextPage() {
    withCurrentSession(
      context,
      (session) {
        context.read<EventParticipationBloc>().add(
              LoadEventParticipationsNextPage(
                eventId: widget.eventDetails.event.id,
                session: session,
              ),
            );
      },
    );
  }

  void _refreshParticipants() {
    withCurrentSession(
      context,
      (session) {
        context.read<EventParticipationBloc>().add(
              RefreshEventParticipations(
                eventId: widget.eventDetails.event.id,
                participationPreview: widget.participationPreview,
                session: session,
              ),
            );
      },
    );
  }
}
