import 'package:bloc/bloc.dart';
import 'package:hollybike/positions/bloc/position_event.dart';
import 'package:hollybike/positions/bloc/position_state.dart';
import 'package:workmanager/workmanager.dart';

class PositionBloc extends Bloc<PositionEvent, PositionState> {
  final taskName = "com.hollybike.hollybike.simplePeriodicTask";

  PositionBloc() : super(PositionInitial()) {
    on<ListenAndSendUserPosition>(_onListenAndSendUserPosition);
    on<DisableSendPositions>(_onDisableSendPositions);
  }

  void _onListenAndSendUserPosition(
    ListenAndSendUserPosition event,
    Emitter<PositionState> emit,
  ) {
    Workmanager().registerOneOffTask(
      taskName,
      taskName,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      inputData: <String, dynamic>{
        'accessToken': event.session.token,
        'host': event.session.host,
        'eventId': event.eventId,
      },
    );
  }

  void _onDisableSendPositions(
    DisableSendPositions event,
    Emitter<PositionState> emit,
  ) {
    Workmanager().cancelByUniqueName(taskName);
  }
}
