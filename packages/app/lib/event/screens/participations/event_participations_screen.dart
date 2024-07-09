import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/app/app_router.gr.dart';
import 'package:hollybike/event/bloc/event_participations_bloc/event_participations_bloc.dart';
import 'package:hollybike/event/bloc/event_participations_bloc/event_participations_event.dart';
import 'package:hollybike/event/bloc/event_participations_bloc/event_participations_state.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_action_icon.dart';
import 'package:hollybike/shared/widgets/hud/hud.dart';

import '../../../shared/widgets/app_toast.dart';
import '../../../shared/widgets/bar/top_bar.dart';
import '../../../shared/widgets/bar/top_bar_title.dart';
import '../../../shared/widgets/loaders/themed_refresh_indicator.dart';
import '../../services/event/event_repository.dart';
import '../../services/participation/event_participation_repository.dart';
import '../../types/participation/event_participation.dart';
import '../../widgets/participations/event_participation_card.dart';

@RoutePage()
class EventParticipationsScreen extends StatefulWidget
    implements AutoRouteWrapper {
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

  @override
  Widget wrappedRoute(context) {
    return BlocProvider<EventParticipationBloc>(
      create: (context) => EventParticipationBloc(
        eventId: eventDetails.event.id,
        eventParticipationsRepository:
            RepositoryProvider.of<EventParticipationRepository>(
          context,
        ),
        eventRepository: RepositoryProvider.of<EventRepository>(context),
      )..add(SubscribeToEventParticipations()),
      child: this,
    );
  }
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
          prefix: TopBarActionIcon(
            onPressed: () => context.router.maybePop(),
            icon: Icons.arrow_back,
          ),
          title: const TopBarTitle("Participants"),
        ),
        floatingActionButton: Builder(builder: (context) {
          if (!widget.eventDetails.isOrganizer) {
            return const SizedBox();
          }

          return FloatingActionButton.extended(
            onPressed: () {
              context.router.push(
                EventCandidatesRoute(
                  eventId: widget.eventDetails.event.id,
                ),
              );
            },
            label: Text(
              'Ajouter',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            icon: const Icon(Icons.group_add),
          );
        }),
        body: ThemedRefreshIndicator(
          onRefresh: () => _refreshParticipants(),
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
              child:
                  BlocBuilder<EventParticipationBloc, EventParticipationsState>(
                builder: (context, state) {
                  final isLoading =
                      state is EventParticipationsPageLoadInProgress &&
                          (state.participants.length ==
                                  widget.participationPreview.length ||
                              state.hasMore);

                  if (state is EventParticipationsPageLoadFailure) {
                    return Center(
                      child: Text(state.errorMessage),
                    );
                  }

                  return _buildList(state.participants, isLoading);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<EventParticipation> participants, bool isLoading) {
    final totalCount = participants.length + (isLoading ? 1 : 0);

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: totalCount,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      itemBuilder: (context, index) {
        if (isLoading && index == totalCount - 1) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

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
    context.read<EventParticipationBloc>().add(
          LoadEventParticipationsNextPage(),
        );
  }

  Future<void> _refreshParticipants() {
    context.read<EventParticipationBloc>().add(
          RefreshEventParticipations(
            participationPreview: widget.participationPreview,
          ),
        );

    return context.read<EventParticipationBloc>().firstWhenNotLoading;
  }
}
