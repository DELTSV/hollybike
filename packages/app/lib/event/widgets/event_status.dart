/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_status_state.dart';
import 'package:hollybike/event/types/minimal_event.dart';

import 'event_dot.dart';

class EventStatusIndicator extends StatefulWidget {
  final MinimalEvent event;
  final void Function()? eventStarted;
  final Text Function(EventStatusState) statusTextBuilder;
  final double separatorWidth;

  const EventStatusIndicator({
    super.key,
    required this.event,
    required this.statusTextBuilder,
    required this.separatorWidth,
    this.eventStarted,
  });

  @override
  State<EventStatusIndicator> createState() => _EventStatusIndicatorState();
}

class _EventStatusIndicatorState extends State<EventStatusIndicator> {
  late Text _statusText;
  late EventStatusState _status;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _status = widget.event.status;
    _statusText = widget.statusTextBuilder(_status);

    setTimer();
  }

  void setTimer() {
    _timer?.cancel();
    _timer = null;

    if (_status != EventStatusState.scheduled) {
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        final newStatus = _statusFromEvent(widget.event);
        final statusText = widget.statusTextBuilder(newStatus);

        final textUpdated = _statusText.data != statusText.data;
        final statusUpdated = _status != newStatus;

        if (statusUpdated && newStatus == EventStatusState.now) {
          widget.eventStarted?.call();
        }

        if (textUpdated || statusUpdated) {
          setState(() {
            _status = newStatus;
            _statusText = statusText;
          });
        }

        if (_status != EventStatusState.scheduled) {
          timer.cancel();
          _timer = null;
        }
      } else {
        timer.cancel();
        _timer = null;
      }
    });
  }

  @override
  void didUpdateWidget(covariant EventStatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.event.status != oldWidget.event.status) {
      setState(() {
        _status = widget.event.status;
        _statusText = widget.statusTextBuilder(_status);
      });

      setTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        EventDot(
          status: _status,
          size: 13,
        ),
        SizedBox(width: widget.separatorWidth),
        Flexible(
          child: _statusText,
        ),
      ],
    );
  }

  EventStatusState _statusFromEvent(MinimalEvent event) {
    final now = DateTime.now().toUtc();

    if (event.status == EventStatusState.scheduled) {
      if (event.startDate.isBefore(now)) {
        return EventStatusState.now;
      } else {
        return EventStatusState.scheduled;
      }
    } else {
      return event.status;
    }
  }
}
