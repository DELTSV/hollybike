part of 'notification_bloc.dart';

typedef Notification = ({String message, bool? isError, String? consumerId});

@immutable
abstract class NotificationState {
  final List<Notification> notifications;

  const NotificationState(this.notifications);
}

class NotificationInitial extends NotificationState {
  NotificationInitial() : super([]);
}

class NotificationPush extends NotificationState {
  NotificationPush(
    NotificationState currentState,
    Notification notification,
  ) : super(currentState.notifications + [notification]);
}

class NotificationDigest extends NotificationState {
  NotificationDigest(NotificationState currentState)
      : super(currentState.notifications.sublist(1));
}
