import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/association/types/association.dart';
import 'package:hollybike/event/bloc/events_bloc/events_event.dart';
import 'package:hollybike/event/bloc/events_bloc/user_events_bloc.dart';
import 'package:hollybike/event/fragments/profile_events.dart';
import 'package:hollybike/event/services/event/event_repository.dart';
import 'package:hollybike/image/services/image_repository.dart';
import 'package:hollybike/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:hollybike/profile/bloc/profile_images_bloc/profile_images_bloc.dart';
import 'package:hollybike/profile/bloc/profile_journeys_bloc/profile_journeys_bloc.dart';
import 'package:hollybike/profile/widgets/profile_banner/profile_banner.dart';
import 'package:hollybike/profile/widgets/profile_description/profile_description.dart';
import 'package:hollybike/profile/widgets/profile_images.dart';
import 'package:hollybike/profile/widgets/profile_journeys.dart';
import 'package:hollybike/profile/widgets/profile_page/placeholder_profile_page.dart';
import 'package:hollybike/shared/widgets/pinned_header_delegate.dart';
import 'package:hollybike/user/types/minimal_user.dart';
import 'package:hollybike/user_journey/services/user_journey_repository.dart';

class ProfilePage extends StatefulWidget {
  final int? id;
  final bool profileLoading;
  final MinimalUser? profile;
  final Association? association;

  const ProfilePage({
    super.key,
    this.id,
    required this.profileLoading,
    required this.profile,
    required this.association,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.profileLoading) {
      return PlaceholderProfilePage(
        loadingProfileId: widget.id,
      );
    }

    if (widget.profile == null) {
      return const Center(
        child: Text(
          'Une erreur est survenue lors de la récupération du profil.',
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, scrolled) => [
          SliverToBoxAdapter(
            child: Column(
              children: [
                ProfileBanner(profile: widget.profile as MinimalUser),
                ProfileDescription(
                  profile: widget.profile as MinimalUser,
                  association: widget.association as Association,
                ),
              ],
            ),
          ),
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverPersistentHeader(
              pinned: true,
              delegate: PinnedHeaderDelegate(
                height: 50,
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: TabBar(
                    labelColor: Theme.of(context).colorScheme.secondary,
                    indicatorColor: Theme.of(context).colorScheme.secondary,
                    tabs: const [
                      Tab(icon: Icon(Icons.event_rounded)),
                      Tab(icon: Icon(Icons.image_rounded)),
                      Tab(icon: Icon(Icons.route_rounded)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        body: _tabBarContent(),
      ),
    );
  }

  Widget _tabBarContent() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserEventsBloc>(
          create: (context) => UserEventsBloc(
            userId: widget.profile!.id,
            eventRepository: RepositoryProvider.of<EventRepository>(context),
          )..add(SubscribeToEvents()),
        ),
        BlocProvider<ProfileImagesBloc>(
          create: (context) => ProfileImagesBloc(
            userId: widget.profile!.id,
            imageRepository: RepositoryProvider.of<ImageRepository>(
              context,
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ProfileJourneysBloc(
            userId: widget.profile!.id,
            userJourneyRepository: RepositoryProvider.of<UserJourneyRepository>(
              context,
            ),
          ),
        ),
      ],
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          final currentProfileEvent = context.read<ProfileBloc>().currentProfile;

          final currentProfile = currentProfileEvent is ProfileLoadSuccessEvent
              ? currentProfileEvent.profile.toMinimalUser()
              : null;

          final isMe = currentProfile?.id == widget.profile?.id;

          return TabBarView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: ProfileEvents(
                  isMe: isMe,
                  username: widget.profile!.username,
                  scrollController: _scrollController,
                ),
              ),
              ProfileImages(
                isMe: isMe,
                username: widget.profile!.username,
                scrollController: _scrollController,
              ),
              ProfileJourneys(
                isMe: isMe,
                user: widget.profile as MinimalUser,
                scrollController: _scrollController,
              )
            ],
          );
        },
      ),
    );
  }
}
