import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_state.dart';
import 'package:hollybike/event/widgets/event_preview_card.dart';
import 'package:hollybike/search/bloc/search_event.dart';
import 'package:hollybike/search/widgets/search_profile_card.dart';
import 'package:hollybike/shared/utils/add_separators.dart';
import 'package:hollybike/shared/utils/with_current_session.dart';
import 'package:hollybike/shared/widgets/bar/top_bar.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_search_input.dart';
import 'package:hollybike/shared/widgets/hud/hud.dart';

import '../../app/app_router.gr.dart';
import '../../event/bloc/event_details_bloc/event_details_bloc.dart';
import '../../event/types/minimal_event.dart';
import '../../shared/widgets/pinned_header_delegate.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_state.dart';

@RoutePage()
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? _lastSearch;
  late final ScrollController _verticalScrollController;
  late final ScrollController _horizontalScrollController;

  @override
  Widget build(BuildContext context) {
    return Hud(
      appBar: TopBar(
        title: TopBarSearchInput(
          defaultValue: _lastSearch,
          onSearchRequested: _handleSearchRequest,
        ),
        noPadding: true,
      ),
      body: BlocListener<EventDetailsBloc, EventDetailsState>(
        listener: (context, state) {
          if (state is DeleteEventSuccess && _lastSearch is String) {
            _refreshSearch(context, _lastSearch as String);
          }
        },
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchInitial || (state.events.isEmpty && state.profiles.isEmpty)) {
              return const Placeholder();
            }

            return CustomScrollView(
              controller: _verticalScrollController,
              slivers: [
                SliverMainAxisGroup(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverPersistentHeader(
                        pinned: true,
                        delegate: PinnedHeaderDelegate(
                          height: 50,
                          animationDuration: 300,
                          child: Container(
                            width: double.infinity,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              child: Text(
                                "Profiles",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 100,
                        child: ListView(
                          controller: _horizontalScrollController,
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                                const SizedBox.square(dimension: 16)
                              ] +
                              addSeparators(
                                state.profiles
                                    .map(
                                      (profile) =>
                                          SearchProfileCard(profile: profile),
                                    )
                                    .toList(),
                                const SizedBox.square(dimension: 8),
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverMainAxisGroup(
                    slivers: [
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: PinnedHeaderDelegate(
                          height: 50,
                          animationDuration: 300,
                          child: Container(
                            width: double.infinity,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              child: Text(
                                "Evenements",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverList.list(
                        children: state.events
                            .map(
                              (event) => EventPreviewCard(
                                event: event,
                                onTap: () {
                                  _navigateToEventDetails(context, event, true);
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      displayNavBar: true,
    );
  }

  @override
  void initState() {
    super.initState();
    _lastSearch = BlocProvider.of<SearchBloc>(context).state.lastSearchQuery;
    
    _verticalScrollController = ScrollController();
    _verticalScrollController.addListener(() {
      var nextPageTrigger = 0.8 * _verticalScrollController.position.maxScrollExtent;

      if (_verticalScrollController.position.pixels > nextPageTrigger) {
        BlocProvider.of<SearchBloc>(context).add(
          LoadEventsSearchNextPage(),
        );
      }
    });
    
    _horizontalScrollController = ScrollController();
    _horizontalScrollController.addListener(() {
      var nextPageTrigger = 0.8 * _horizontalScrollController.position.maxScrollExtent;

      if (_horizontalScrollController.position.pixels > nextPageTrigger) {
        BlocProvider.of<SearchBloc>(context).add(
          LoadProfilesSearchNextPage(),
        );
      }
    });
  }

  void _navigateToEventDetails(
    BuildContext context,
    MinimalEvent event,
    bool animate,
  ) {
    // delay 200 ms to allow the animation to finish
    Future.delayed(const Duration(milliseconds: 200), () {
      context.router.push(EventDetailsRoute(
        event: event,
        animate: animate,
      ));
    });
  }

  void _handleSearchRequest(String query) {
    if (query == _lastSearch) return;

    _refreshSearch(context, query);
    setState(() => _lastSearch = query);
  }

  void _refreshSearch(BuildContext context, String query) {
    withCurrentSession(
      context,
      (session) {
        BlocProvider.of<SearchBloc>(context).add(
          RefreshSearch(session: session, query: query),
        );
      },
    );
  }
}
