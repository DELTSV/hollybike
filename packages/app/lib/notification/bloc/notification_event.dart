part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {}

final class PushNotification extends NotificationEvent {
  final String message;
  final bool? isError;
  final String? consumerId;

  PushNotification({
    required this.message,
    this.isError,
    this.consumerId,
  });

  Notification toNotification() =>
      (message: message, isError: isError, consumerId: consumerId);
}

final class ConsumedNotification extends NotificationEvent {}
