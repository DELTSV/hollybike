import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_state.dart';
import 'package:hollybike/event/widgets/event_preview_card.dart';
import 'package:hollybike/search/bloc/search_event.dart';
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
  String? lastSearch;

  @override
  Widget build(BuildContext context) {
    return Hud(
      appBar: TopBar(
        title: TopBarSearchInput(
          defaultValue: lastSearch,
          onSearchRequested: _handleSearchRequest,
        ),
        noPadding: true,
      ),
      body: BlocListener<EventDetailsBloc, EventDetailsState>(
        listener: (context, state) {
          if (state is DeleteEventSuccess && lastSearch is String) {
            _refreshSearch(context, lastSearch as String);
          }
        },
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state.status != SearchStatus.success) {
              return const Placeholder();
            }

            return CustomScrollView(
              slivers: [
                SliverMainAxisGroup(
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
                              "Profiles",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 120,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: state.profiles
                              .map((profile) => Text(profile.email))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                SliverMainAxisGroup(
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
              ],
            );
          },
        ),
      ),
      displayNavBar: true,
    );
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
    if (query == lastSearch) return;

    _refreshSearch(context, query);
    setState(() => lastSearch = query);
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
