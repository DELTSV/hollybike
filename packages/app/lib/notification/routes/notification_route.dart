import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/notification/bloc/notification_bloc.dart';

@RoutePage()
class NotificationRoute extends StatelessWidget {
  const NotificationRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state.isConcerned()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.notifications.first.message),
              ),
            );

            BlocProvider.of<NotificationBloc>(context).add(
              ConsumedNotification(),
            );
          }
        },
        child: const AutoRouter(),
      ),
    );
  }
}
