/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {}

class InitNotificationService extends NotificationEvent {
  InitNotificationService();
}