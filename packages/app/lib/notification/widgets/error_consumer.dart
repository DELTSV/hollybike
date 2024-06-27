import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/notification_bloc.dart';
import 'error_box.dart';

class ErrorConsumer extends StatefulWidget {
  final String notificationsConsumerId;

  const ErrorConsumer({super.key, required this.notificationsConsumerId});

  @override
  State<ErrorConsumer> createState() => _ErrorConsumerState();
}

class _ErrorConsumerState extends State<ErrorConsumer> {
  String? error;

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationBloc, NotificationState>(
      listener: _handleNotificationStateChange,
      child: Column(
        children: _renderError(),
      ),
    );
  }

  List<Widget> _renderError() {
    if (error == null) return <Widget>[];
    return <Widget>[
      ErrorBox(
        error: error as String,
        onCloseButtonClick: () => setState(() {
          error = null;
        }),
      ),
    ];
  }

  void _handleNotificationStateChange(
    BuildContext context,
    NotificationState state,
  ) {
    if (state.isConcerned(consumerId: widget.notificationsConsumerId)) {
      setState(() {
        error = state.notification.message;
      });
      BlocProvider.of<NotificationBloc>(context).add(ConsumedNotification());
    }
  }
}
