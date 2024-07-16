/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
part of 'notification_bloc.dart';

typedef Notification = ({String message, bool? isError, String? consumerId});

@immutable
abstract class NotificationState {
}

class NotificationInitial extends NotificationState {}