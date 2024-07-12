import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_event.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_state.dart';
import 'package:hollybike/shared/widgets/app_toast.dart';
import 'package:hollybike/user/types/minimal_user.dart';
import 'package:hollybike/user_journey/bloc/user_journey_details_bloc.dart';
import 'package:hollybike/user_journey/bloc/user_journey_details_event.dart';
import 'package:hollybike/user_journey/bloc/user_journey_details_state.dart';
import 'package:hollybike/user_journey/services/user_journey_repository.dart';
import 'package:hollybike/user_journey/type/user_journey.dart';
import 'package:hollybike/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:hollybike/shared/utils/add_separators.dart';
import 'package:hollybike/user_journey/widgets/user_journey_content.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../event/bloc/event_details_bloc/event_details_bloc.dart';
import '../../shared/utils/dates.dart';
import '../../shared/widgets/bloc_provided_builder.dart';
import '../../shared/widgets/gradient_progress_bar.dart';

enum JourneyModalAction {
  resetJourney,
  deleteJourney,
  downloadJourney,
}

class UserJourneyModal extends StatefulWidget {
  final UserJourney journey;
  final bool isCurrentEvent;
  final MinimalUser? user;

  const UserJourneyModal({
    super.key,
    required this.journey,
    required this.isCurrentEvent,
    this.user,
  });

  @override
  State<UserJourneyModal> createState() => _UserJourneyModalState();
}

class _UserJourneyModalState extends State<UserJourneyModal> {
  late final double _betterPercentage;
  bool _isSolo = false;
  int _betterThanCount = 0;

  @override
  void initState() {
    super.initState();
    final isBetterThan = widget.journey.isBetterThan;

    if (isBetterThan.isEmpty) {
      _isSolo = true;
      _betterPercentage = 0.0;
      return;
    }

    _betterPercentage = isBetterThan.entries.fold(0.0, (acc, entry) {
          final isBetter = entry.value;
          return acc + isBetter;
        }) /
        isBetterThan.length;

    _betterThanCount =
        isBetterThan.values.where((element) => element == 100).length;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserJourneyDetailsBloc(
        userJourneyRepository:
            RepositoryProvider.of<UserJourneyRepository>(context),
        journeyId: widget.journey.id,
      ),
      child: BlocConsumer(
        listener: (context, state) {
          if (state is UserJourneyReset) {
            Navigator.of(context).pop();
            Toast.showSuccessToast(context, 'Parcours réinitialisé');
          }
        },
        bloc: context.readOrNull<EventDetailsBloc>(),
        builder: (context, eventState) {
          return BlocConsumer<UserJourneyDetailsBloc, UserJourneyDetailsState>(
            listener: (context, state) {
              if (state is UserJourneyDeleted) {
                Navigator.of(context).pop();
                Toast.showSuccessToast(
                  context,
                  'Parcours supprimé',
                );
              }

              if (state is UserJourneyOperationSuccess) {
                Toast.showSuccessToast(context, state.successMessage);
              }

              if (state is UserJourneyOperationFailure) {
                Toast.showErrorToast(context, state.errorMessage);
              }
            },
            builder: (context, userJourneyState) {
              final isLoading =
                  userJourneyState is UserJourneyOperationInProgress ||
                      eventState is EventOperationInProgress;

              print('isLoading: $isLoading');

              return _buildContent(isLoading);
            },
          );
        },
      ),
    );
  }

  Widget _buildContent(bool isLoading) {
    return Container(
      decoration: _modalDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
        ),
        child: SafeArea(
          child: BlocProvidedBuilder<ProfileBloc, ProfileState>(
            builder: (context, bloc, _) {
              final currentProfileEvent = bloc.currentProfile;
              final currentUserId =
                  (currentProfileEvent is ProfileLoadSuccessEvent
                      ? currentProfileEvent.profile.id
                      : null);

              final isCurrentUser =
                  widget.user?.id == null || (currentUserId == widget.user?.id);

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context, isCurrentUser, isLoading),
                  const SizedBox(height: 16),
                  _JourneyInfoRow(
                    icon: Icons.history,
                    text:
                        "Parcours terminé ${formatTimeDate(widget.journey.createdAt.toLocal())}",
                  ),
                  const SizedBox(height: 8),
                  _JourneyInfoRow(
                    icon: Icons.route_outlined,
                    text:
                        '${widget.journey.distanceLabel} - ${widget.journey.totalTimeLabel}',
                    titleStyle: Theme.of(context).textTheme.titleMedium,
                    bodyStyle: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GradientProgressBar(
                          animateStart: true,
                          maxValue: 100,
                          value: _betterPercentage,
                          colors: [
                            Colors.red.shade400,
                            Colors.yellow.shade400,
                            Colors.green.shade400,
                          ],
                        ),
                        const SizedBox(height: 8),
                        _getIsBetterLabel(isCurrentUser),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._buildBetterThanCount(isCurrentUser),
                  _JourneyStatRow(
                    firstStat: _JourneyStatCard(
                      title: 'Dénivelé gains et pertes',
                      stats: [
                        _StatItem(
                          icon: Icons.north_east_rounded,
                          label:
                              '${widget.journey.totalElevationGain?.round()} m',
                          value: getBetterThan('total_elevation_gain'),
                        ),
                        _StatItem(
                          icon: Icons.south_east_rounded,
                          label:
                              '${widget.journey.totalElevationLoss?.round()} m',
                          value: getBetterThan('total_elevation_loss'),
                        ),
                      ],
                    ),
                    secondStat: _JourneyStatCard(
                      title: 'Vitesse maximale et moyenne',
                      stats: [
                        _StatItem(
                          icon: Icons.speed_rounded,
                          label: widget.journey.maxSpeedLabel,
                          value: getBetterThan('max_speed'),
                        ),
                        _StatItem(
                          icon: Icons.speed_rounded,
                          label: widget.journey.avgSpeedLabel,
                          value: getBetterThan('avg_speed'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _JourneyStatRow(
                    firstStat: _JourneyStatCard(
                      title: 'Altitude minimale et maximale',
                      stats: [
                        _StatItem(
                          icon: Icons.vertical_align_bottom_rounded,
                          label: '${widget.journey.minElevation?.round()} m',
                          value: getBetterThan('min_elevation'),
                        ),
                        _StatItem(
                          icon: Icons.terrain_rounded,
                          label: '${widget.journey.maxElevation?.round()} m',
                          value: getBetterThan('max_elevation'),
                        ),
                      ],
                    ),
                    secondStat: _JourneyStatCard(
                      title: 'Accélération maximale et moyenne',
                      stats: [
                        _StatItem(
                          icon: Icons.gps_fixed_rounded,
                          label: widget.journey.maxGForceLabel,
                          value: getBetterThan('max_g_force'),
                        ),
                        _StatItem(
                          icon: Icons.gps_fixed_rounded,
                          label: widget.journey.avgGForceLabel,
                          value: getBetterThan('avg_g_force'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBetterThanCount(bool isCurrentUser) {
    if (_betterThanCount == 0) {
      return [];
    }

    return [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Lottie.asset(
              "assets/lottie/lottie_medal.json",
              width: 35,
              repeat: true,
            ),
            const SizedBox(width: 16),
            Flexible(
              child: Text(
                _getIsBetterThanCountText(isCurrentUser),
                style: Theme.of(context).textTheme.bodyMedium,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
    ];
  }

  String _getIsBetterThanCountText(bool isCurrentUser) {
    if (isCurrentUser) {
      return 'Vous êtes le meilleur dans $_betterThanCount catégories !';
    } else {
      return '${widget.user?.username} est le meilleur dans $_betterThanCount catégories !';
    }
  }

  double? getBetterThan(String key) {
    if (widget.journey.isBetterThan.containsKey(key)) {
      return widget.journey.isBetterThan[key];
    }

    return null;
  }

  Widget _getIsBetterLabel(bool isCurrentUser) {
    return Text(
      _isSolo
          ? "Vous êtes le seul à avoir terminé le parcours !"
          : "${_getIsBetterMeanText(isCurrentUser)} ${(_betterPercentage).round()}% des participants !",
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  String _getIsBetterMeanText(bool isCurrentUser) {
    if (isCurrentUser) {
      return 'Vous avez fait mieux que';
    } else {
      return '${widget.user?.username} a fait mieux que';
    }
  }

  BoxDecoration _modalDecoration() {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.primary,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(31),
        topRight: Radius.circular(31),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isCurrentUser, isLoading) {
    return isCurrentUser
        ? _buildCurrentUserHeader(context, isLoading)
        : _buildOtherUserHeader();
  }

  Widget _buildCurrentUserHeader(BuildContext context, bool isLoading) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildActionButton(context, isLoading),
        const Spacer(),
        ElevatedButton(
          onPressed: () => {},
          child: const Text('Voir sur la carte'),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, bool isLoading) {
    return SizedBox(
      height: 40,
      child: AnimatedCrossFade(
        firstChild: PopupMenuButton(
          onSelected: (action) => _handleModalAction(context, action),
          itemBuilder: (context) => _buildJourneyActions(),
        ),
        secondChild: const Padding(
          padding: EdgeInsets.all(5.0),
          child: AspectRatio(
            aspectRatio: 1,
            child: CircularProgressIndicator(),
          ),
        ),
        crossFadeState:
            isLoading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _handleModalAction(BuildContext context, JourneyModalAction action) {
    switch (action) {
      case JourneyModalAction.resetJourney:
        context.read<EventDetailsBloc>().add(ResetUserJourney());
        break;
      case JourneyModalAction.deleteJourney:
        context.read<UserJourneyDetailsBloc>().add(DeleteUserJourney());
        break;
      case JourneyModalAction.downloadJourney:
        context.read<UserJourneyDetailsBloc>().add(DownloadUserJourney(
              fileName: _getJourneyFileName(),
            ));
        break;
    }
  }

  String _getJourneyFileName() {
    final date =
        DateFormat('dd-MM-yyyy').format(widget.journey.createdAt.toLocal());

    final uniqueKey = DateTime.now().microsecondsSinceEpoch.toString();

    return 'parcours_${date}_$uniqueKey.gpx';
  }

  Widget _buildOtherUserHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            'Parcours de ${widget.user?.username}',
            style: Theme.of(context).textTheme.titleMedium,
            softWrap: true,
          ),
        ),
      ],
    );
  }

  List<PopupMenuItem> _buildJourneyActions() {
    final actions = <PopupMenuItem>[];

    if (widget.isCurrentEvent) {
      actions.add(
        const PopupMenuItem(
          value: JourneyModalAction.resetJourney,
          child: Row(
            children: [
              Icon(Icons.restart_alt_rounded),
              SizedBox(width: 8),
              Text('Réinitialiser le parcours'),
            ],
          ),
        ),
      );
    } else {
      actions.add(
        const PopupMenuItem(
          value: JourneyModalAction.deleteJourney,
          child: Row(
            children: [
              Icon(Icons.delete_rounded),
              SizedBox(width: 8),
              Text('Supprimer le parcours'),
            ],
          ),
        ),
      );
    }

    return [
      ...actions,
      const PopupMenuItem(
        value: JourneyModalAction.downloadJourney,
        child: Row(
          children: [
            Icon(Icons.download_rounded),
            SizedBox(width: 8),
            Text('Télécharger le parcours'),
          ],
        ),
      ),
    ];
  }
}

class _JourneyInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final TextStyle? titleStyle;
  final TextStyle? bodyStyle;

  const _JourneyInfoRow({
    required this.icon,
    required this.text,
    this.titleStyle,
    this.bodyStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Text(
          text,
          style: titleStyle ?? Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _JourneyStatRow extends StatelessWidget {
  final Widget firstStat;
  final Widget secondStat;

  const _JourneyStatRow({
    required this.firstStat,
    required this.secondStat,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Flexible(child: firstStat),
          const SizedBox(width: 16),
          Flexible(child: secondStat),
        ],
      ),
    );
  }
}

class _JourneyStatCard extends StatelessWidget {
  final String title;
  final List<_StatItem> stats;

  const _JourneyStatCard({
    required this.title,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              softWrap: true,
            ),
          ),
          const SizedBox(height: 8),
          const Spacer(),
          ...addSeparators(stats, const SizedBox(height: 8)),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final double? value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            children: _getStats(context),
          ),
        ),
        if (value == 100)
          Positioned(
            left: 9,
            top: -2,
            child: Lottie.asset(
              "assets/lottie/lottie_medal.json",
              width: 15,
              repeat: true,
            ),
          ),
      ],
    );
  }

  List<Widget> _getStats(BuildContext context) {
    final widgets = <Widget>[
      Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    ];

    if (value != null) {
      widgets.addAll([
        const SizedBox(height: 2),
        GradientProgressBar(
          animateStart: true,
          maxValue: 100,
          value: value!,
          height: 3,
          colors: [
            Colors.red.shade400,
            Colors.yellow.shade400,
            Colors.green.shade400,
          ],
        ),
      ]);
    }

    return widgets;
  }
}