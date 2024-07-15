import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/types/minimal_event.dart';
import 'package:hollybike/event/widgets/event_status.dart';
import 'package:hollybike/positions/bloc/my_position/my_position_bloc.dart';
import 'package:hollybike/positions/bloc/my_position/my_position_state.dart';
import 'package:hollybike/shared/utils/safe_set_state.dart';

import '../../../shared/utils/dates.dart';
import '../../types/event_status_state.dart';
import '../event_form/event_date.dart';

class EventPreviewCard extends StatefulWidget {
  final MinimalEvent event;
  final void Function(String uniqueKey) onTap;

  const EventPreviewCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  State<EventPreviewCard> createState() => _EventPreviewCardState();
}

class _EventPreviewCardState extends State<EventPreviewCard> {
  late String _uniqueKey;
  bool _animate = true;

  @override
  void initState() {
    super.initState();
    _uniqueKey = _getUniqueKey();
  }

  @override
  void didUpdateWidget(covariant EventPreviewCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.event.id != widget.event.id) {
      _uniqueKey = _getUniqueKey();
      _animate = false;

      Future.delayed(Duration.zero, () {
        safeSetState(() {
          _animate = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        height: 110,
        child: Stack(
          children: [
            Positioned.fill(
              bottom: 0,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 110,
                      child: _animate
                          ? Hero(
                              tag: "event-image-$_uniqueKey",
                              child: _buildImage(),
                            )
                          : _buildImage(),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LayoutBuilder(builder: (context, constraints) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (_animate)
                                Hero(
                                  tag: "event-name-$_uniqueKey",
                                  child: _buildTitle(constraints.maxWidth),
                                ),
                              if (!_animate) _buildTitle(constraints.maxWidth),
                              EventStatusIndicator(
                                event: widget.event,
                                separatorWidth: 5,
                                statusTextBuilder: (status) {
                                  switch (status) {
                                    case EventStatusState.canceled:
                                      return const Text("Annulé");
                                    case EventStatusState.pending:
                                      return const Text("En attente");
                                    case EventStatusState.now:
                                      return const Text("En cours");
                                    case EventStatusState.finished:
                                      return const Text("Terminé");
                                    case EventStatusState.scheduled:
                                      return Text(
                                        fromDateToDuration(
                                          widget.event.startDate,
                                        ),
                                      );
                                  }
                                },
                              ),
                            ],
                          );
                        }),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  onTap: () => widget.onTap(_uniqueKey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(double width) {
    return SizedBox(
      width: width,
      child: Text(
        widget.event.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _buildImage() {
    return BlocBuilder<MyPositionBloc, MyPositionState>(
      builder: (context, state) {
        return Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Container(
                foregroundDecoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Theme.of(context).cardColor.withOpacity(0.5),
                      Theme.of(context).cardColor,
                    ],
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(10),
                  ),
                  child: Image(
                    image: widget.event.imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: EventDate(date: widget.event.startDate),
            ),
            if (widget.event.id == state.eventId)
              Positioned(
                top: 8,
                left: 8,
                child: Icon(
                  Icons.location_on,
                  color: Colors.lightBlueAccent.shade200,
                  size: 18,
                ),
              ),
          ],
        );
      },
    );
  }

  String _getUniqueKey() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }
}
