import 'package:flutter/material.dart';
import 'package:hollybike/profile/widgets/profile_banner/profile_banner.dart';
import 'package:hollybike/profile/widgets/profile_description/profile_description.dart';
import 'package:hollybike/event/fragments/profile_events.dart';
import 'package:hollybike/profile/widgets/profile_page/placeholder_profile_page.dart';
import 'package:hollybike/shared/widgets/pinned_header_delegate.dart';

import '../../types/profile.dart';

class ProfilePage extends StatefulWidget {
  final int? id;
  final Profile? profile;

  const ProfilePage({super.key, this.id, required this.profile});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ScrollController _scrollController;
  final scrollViewKey = GlobalKey<NestedScrollViewState>();

  @override
  Widget build(BuildContext context) {
    if (widget.profile == null) {
      return PlaceholderProfilePage(
        loadingProfileId: widget.id,
      );
    }

    return DefaultTabController(
      length: 1,
      child: NestedScrollView(
        key: scrollViewKey,
        controller: _scrollController,
        headerSliverBuilder: (context, scrolled) => [
          SliverToBoxAdapter(
            child: Column(
              children: [
                ProfileBanner(profile: widget.profile as Profile),
                ProfileDescription(profile: widget.profile as Profile),
              ],
            ),
          ),
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverPersistentHeader(
              pinned: true,
              delegate: PinnedHeaderDelegate(
                height: 50,
                child: TabBar(
                  labelColor: Theme.of(context).colorScheme.secondary,
                  indicatorColor: Theme.of(context).colorScheme.secondary,
                  tabs: const [Tab(icon: Icon(Icons.event))],
                ),
              ),
            ),
          ),
        ],
        body: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: TabBarView(
            children: [
              ProfileEvents(
                userId: widget.profile!.id,
                scrollView: scrollViewKey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
