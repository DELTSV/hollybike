import 'package:hollybike/notification/bloc/notification_bloc.dart';

class NotificationRepository {
  final NotificationBloc notificationBloc;

  NotificationRepository({required this.notificationBloc});

  void push(
    String message, {
    bool? isError,
    String? consumerId,
  }) {
    notificationBloc.add(
      PushNotification(
        message: message,
        isError: isError,
        consumerId: consumerId,
      ),
    );
  }
}
