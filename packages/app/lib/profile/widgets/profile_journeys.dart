import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/widgets/events_list/events_list_placeholder.dart';
import 'package:hollybike/profile/bloc/profile_journeys_bloc/profile_journeys_bloc.dart';
import 'package:hollybike/profile/bloc/profile_journeys_bloc/profile_journeys_event.dart';
import 'package:hollybike/profile/bloc/profile_journeys_bloc/profile_journeys_state.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';
import 'package:hollybike/user/types/minimal_user.dart';
import 'package:hollybike/user_journey/type/user_journey.dart';
import 'package:hollybike/user_journey/widgets/user_journey_list.dart';
import 'package:lottie/lottie.dart';

class ProfileJourneys extends StatefulWidget {
  final MinimalUser user;
  final bool isMe;
  final ScrollController scrollController;
  final bool isNested;
  final void Function(UserJourney)? onJourneySelected;

  const ProfileJourneys({
    super.key,
    required this.user,
    required this.isMe,
    required this.scrollController,
    this.isNested = true,
    this.onJourneySelected,
  });

  @override
  State<ProfileJourneys> createState() => _ProfileJourneysState();
}

class _ProfileJourneysState extends State<ProfileJourneys> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileJourneysBloc>().add(RefreshProfileJourneys());

    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    var nextPageTrigger =
        0.8 * widget.scrollController.position.maxScrollExtent;

    if (widget.scrollController.position.pixels > nextPageTrigger) {
      context.read<ProfileJourneysBloc>().add(LoadProfileJourneysNextPage());
    }
  }

  Future<void> _onRefresh() {
    context.read<ProfileJourneysBloc>().add(RefreshProfileJourneys());

    return context.read<ProfileJourneysBloc>().firstWhenNotLoading;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileJourneysBloc, ProfileJourneysState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ThemedRefreshIndicator(
            onRefresh: _onRefresh,
            child: _buildList(
              state.userJourneys,
              state.hasMore,
              state.status,
            ),
          ),
        );
      },
    );
  }

  Widget _buildList(
    List<UserJourney> userJourneys,
    bool hasMore,
    ProfileJourneysStatus status,
  ) {
    if (userJourneys.isEmpty) {
      return _buildPlaceholder(context, status);
    }

    return UserJourneyList(
      hasMore: hasMore,
      userJourneys: userJourneys,
      user: widget.user,
      isNested: widget.isNested,
      onJourneySelected: widget.onJourneySelected,
    );
  }

  Widget _buildPlaceholder(BuildContext context, ProfileJourneysStatus status) {
    switch (status) {
      case ProfileJourneysStatus.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case ProfileJourneysStatus.error:
        return ScrollablePlaceholder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: MediaQuery.of(context).size.width * 0.1,
          child: const Center(
            child: Text(
              'Une erreur est survenue lors du chargement des trajets, veuillez réessayer.',
              textAlign: TextAlign.center,
            ),
          ),
        );
      case ProfileJourneysStatus.success:
        return ScrollablePlaceholder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: MediaQuery.of(context).size.width * 0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                child: Lottie.asset(
                  fit: BoxFit.cover,
                  'assets/lottie/lottie_journey.json',
                  repeat: false,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.isMe
                    ? 'Vous n\'avez terminé aucun trajet'
                    : '${widget.user.username} n\'a pas encore terminé de trajets',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }
}
