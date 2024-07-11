import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/journey/type/user_journey.dart';
import 'package:hollybike/profile/bloc/profile_bloc/profile_bloc.dart';
import '../../../shared/utils/dates.dart';
import '../../../shared/widgets/gradient_progress_bar.dart';

enum JourneyModalAction {
  resetJourney,
  downloadJourney,
}

class EventParticipationJourneyModal extends StatefulWidget {
  final UserJourney journey;
  final int userId;
  final String? username;

  const EventParticipationJourneyModal({
    super.key,
    required this.journey,
    required this.userId,
    this.username,
  });

  @override
  State<EventParticipationJourneyModal> createState() => _EventParticipationJourneyModalState();
}

class _EventParticipationJourneyModalState extends State<EventParticipationJourneyModal> {
  late final double _betterPercentage;

  @override
  void initState() {
    super.initState();
    final isBetterThan = widget.journey.isBetterThan;

    _betterPercentage = isBetterThan.entries.fold(0.0, (acc, entry) {
      final isBetter = entry.value;
      return acc + isBetter;
    }) / isBetterThan.length;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _modalDecoration(context),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
        ),
        child: SafeArea(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              final currentProfile = state.currentProfile;
              final isCurrentUser = currentProfile?.id == widget.userId;

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context, isCurrentUser),
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
                        Text(
                          "${_getIsBetterMeanText(isCurrentUser)} ${(_betterPercentage).round()}% des participants !",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _JourneyStatRow(
                    firstStat: _JourneyStatCard(
                      title: 'Dénivelé gains et pertes',
                      stats: [
                        _StatItem(
                          icon: Icons.north_east_rounded,
                          label: '${widget.journey.totalElevationGain?.round()} m',
                        ),
                        _StatItem(
                          icon: Icons.south_east_rounded,
                          label: '${widget.journey.totalElevationLoss?.round()} m',
                        ),
                      ],
                    ),
                    secondStat: _JourneyStatCard(
                      title: 'Vitesse maximale et moyenne',
                      stats: [
                        _StatItem(
                          icon: Icons.speed_rounded,
                          label: widget.journey.maxSpeedLabel,
                        ),
                        _StatItem(
                          icon: Icons.speed_rounded,
                          label: widget.journey.avgSpeedLabel,
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
                        ),
                        _StatItem(
                          icon: Icons.terrain_rounded,
                          label: '${widget.journey.maxElevation?.round()} m',
                        ),
                      ],
                    ),
                    secondStat: _JourneyStatCard(
                      title: 'Accélération maximale et moyenne',
                      stats: [
                        _StatItem(
                          icon: Icons.gps_fixed_rounded,
                          label: widget.journey.maxGForceLabel,
                        ),
                        _StatItem(
                          icon: Icons.gps_fixed_rounded,
                          label: widget.journey.avgGForceLabel,
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

  String _getIsBetterMeanText(bool isCurrentUser) {
    if (isCurrentUser) {
      return 'Vous avez fait mieux que';
    } else if (widget.username != null) {
      return '${widget.username} a fait mieux que';
    } else {
      return 'Le participant a fait mieux que';
    }
  }

  BoxDecoration _modalDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.primary,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(31),
        topRight: Radius.circular(31),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isCurrentUser) {
    return isCurrentUser
        ? _buildCurrentUserHeader(context)
        : _buildOtherUserHeader(context);
  }

  Widget _buildCurrentUserHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PopupMenuButton(
          onSelected: (value) {
            // Handle modal action
          },
          itemBuilder: (context) {
            return _buildJourneyActions();
          },
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () => {},
          child: const Text('Voir sur la carte'),
        ),
      ],
    );
  }

  Widget _buildOtherUserHeader(BuildContext context) {
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
            'Parcours de ${widget.username}',
            style: Theme.of(context).textTheme.titleMedium,
            softWrap: true,
          ),
        ),
      ],
    );
  }

  List<PopupMenuItem> _buildJourneyActions() {
    return [
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
            softWrap: true,
          ),
          const SizedBox(height: 8),
          const Spacer(),
          ...stats,
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
