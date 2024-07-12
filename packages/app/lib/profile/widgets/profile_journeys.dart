import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/profile/bloc/profile_journeys_bloc/profile_journeys_bloc.dart';
import 'package:hollybike/profile/bloc/profile_journeys_bloc/profile_journeys_event.dart';
import 'package:hollybike/profile/bloc/profile_journeys_bloc/profile_journeys_state.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';
import 'package:hollybike/user/types/minimal_user.dart';
import 'package:hollybike/user_journey/widgets/user_journey_card.dart';
import 'package:hollybike/user_journey/widgets/user_journey_list.dart';

class ProfileJourneys extends StatefulWidget {
  final MinimalUser user;
  final ScrollController scrollController;

  const ProfileJourneys({
    super.key,
    required this.user,
    required this.scrollController,
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
            child: UserJourneyList(
              hasMore: state.hasMore,
              userJourneys: state.userJourneys,
              user: widget.user,
            ),
          ),
        );
      },
    );
  }
}
