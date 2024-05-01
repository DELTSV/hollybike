import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<PushNotification>((event, emit) {
      emit(NotificationPush(state, event.toNotification()));
    });

    on<ConsumedNotification>((event,emit) {
      emit(NotificationDigest(state));
    });
  }
}
