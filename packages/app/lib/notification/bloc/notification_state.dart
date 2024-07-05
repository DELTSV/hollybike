part of 'notification_bloc.dart';

typedef Notification = ({String message, bool? isError, String? consumerId});

@immutable
abstract class NotificationState {
}

class NotificationInitial extends NotificationState {}