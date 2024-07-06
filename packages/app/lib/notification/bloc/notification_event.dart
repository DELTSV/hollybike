part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {}

class InitNotificationService extends NotificationEvent {
  InitNotificationService();
}