import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_candidates_bloc/event_candidates_bloc.dart';
import 'package:hollybike/event/bloc/event_candidates_bloc/event_candidates_event.dart';
import 'package:hollybike/event/bloc/event_candidates_bloc/event_candidates_state.dart';
import 'package:hollybike/event/widgets/candidates/event_candidate_card.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_action_icon.dart';

import '../../../shared/widgets/app_toast.dart';
import '../../../shared/widgets/bar/top_bar.dart';
import '../../../shared/widgets/bar/top_bar_title.dart';
import '../../../shared/widgets/hud/hud.dart';
import '../../services/event/event_repository.dart';
import '../../services/participation/event_participation_repository.dart';

@RoutePage()
class EventCandidatesScreen extends StatefulWidget implements AutoRouteWrapper {
  final int eventId;

  const EventCandidatesScreen({super.key, required this.eventId});

  @override
  State<EventCandidatesScreen> createState() => _EventCandidatesScreenState();

  @override
  Widget wrappedRoute(context) {
    return BlocProvider<EventCandidatesBloc>(
      create: (context) => EventCandidatesBloc(
        eventId: eventId,
        eventParticipationsRepository:
            RepositoryProvider.of<EventParticipationRepository>(
          context,
        ),
        eventRepository: RepositoryProvider.of<EventRepository>(context),
      )..add(SubscribeToEventCandidates()),
      child: this,
    );
  }
}

class _EventCandidatesScreenState extends State<EventCandidatesScreen> {
  late ScrollController _scrollController;
  Timer? _searchDebounceTimer;
  String _searchQuery = "";

  final List<int> _selectedCandidates = [];

  @override
  void initState() {
    super.initState();

    _refreshCandidates();

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      var nextPageTrigger = 0.8 * _scrollController.position.maxScrollExtent;

      if (_scrollController.position.pixels > nextPageTrigger) {
        _loadNextPage();
      }
    });
  }

  void _onCandidateSelected(int candidateId) {
    setState(() {
      if (_selectedCandidates.contains(candidateId)) {
        _selectedCandidates.remove(candidateId);
      } else {
        _selectedCandidates.add(candidateId);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _searchDebounceTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventCandidatesBloc, EventCandidatesState>(
      listener: (context, state) {
        if (state is EventCandidatesPageLoadFailure) {
          Toast.showErrorToast(context, state.errorMessage);
        } else if (state is EventAddCandidatesFailure) {
          Toast.showErrorToast(context, state.errorMessage);
        } else if (state is EventAddCandidatesSuccess) {
          Toast.showSuccessToast(context, "Participants ajoutés");
          context.router.maybePop();
        }
      },
      child: Builder(builder: (context) {
        Widget? floatingActionButton;

        if (_selectedCandidates.isNotEmpty) {
          floatingActionButton = FloatingActionButton.extended(
            onPressed: _addCandidates,
            label: Text(
              "Ajouter ${_selectedCandidates.length} participants",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            icon: const Icon(Icons.add),
          );
        }

        return Hud(
          appBar: TopBar(
            prefix: TopBarActionIcon(
              onPressed: () => context.router.maybePop(),
              icon: Icons.arrow_back,
            ),
            title: const TopBarTitle("Ajouter des participants"),
          ),
          floatingActionButton: floatingActionButton,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.search),
                    labelText: "Rechercher un utilisateur",
                    fillColor: Theme.of(context).colorScheme.primaryContainer,
                    filled: true,
                  ),
                  onChanged: _onSearchCandidates,
                ),
                BlocBuilder<EventCandidatesBloc, EventCandidatesState>(
                  builder: (context, state) {
                    if (state is EventCandidatesPageLoadInProgress) {
                      return const Column(
                        children: [
                          SizedBox(height: 32),
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      );
                    }

                    if (state is EventCandidatesPageLoadFailure) {
                      return Column(
                        children: [
                          const SizedBox(height: 32),
                          Center(
                            child: Text(state.errorMessage),
                          ),
                        ],
                      );
                    }

                    if (state.candidates.isEmpty) {
                      return Column(
                        children: [
                          const SizedBox(height: 32),
                          Center(
                            child: _searchQuery.isEmpty
                                ? const Text(
                                    "Tous les utilisateurs sont déjà inscrits")
                                : const Text("Aucun utilisateur trouvé"),
                          ),
                        ],
                      );
                    }

                    return Expanded(
                      child: ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemCount: state.candidates.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final candidate = state.candidates[index];

                          return EventCandidateCard(
                            candidate: candidate,
                            alreadyParticipating: candidate.eventRole != null,
                            isSelected:
                                _selectedCandidates.contains(candidate.id) ||
                                    candidate.eventRole != null,
                            onTap: () => _onCandidateSelected(candidate.id),
                          );
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  void _addCandidates() {
    context.read<EventCandidatesBloc>().add(
          AddCandidates(
            eventId: widget.eventId,
            userIds: _selectedCandidates,
          ),
        );
  }

  void _onSearchCandidates(String query) {
    setState(() {
      _searchQuery = query;
    });
    if (_searchDebounceTimer?.isActive ?? false) _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      _searchCandidates(query);
    });
  }

  void _refreshCandidates() {
    context.read<EventCandidatesBloc>().add(
          RefreshEventCandidates(
            eventId: widget.eventId,
          ),
        );
  }

  void _loadNextPage() {
    context.read<EventCandidatesBloc>().add(
          LoadEventCandidatesNextPage(
            eventId: widget.eventId,
          ),
        );
  }

  void _searchCandidates(String query) {
    context.read<EventCandidatesBloc>().add(
          SearchCandidates(
            eventId: widget.eventId,
            search: query,
          ),
        );
  }
}
