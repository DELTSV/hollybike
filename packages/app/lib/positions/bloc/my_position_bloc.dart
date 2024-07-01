import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator_2/background_locator.dart';
import 'package:bloc/bloc.dart';
import 'package:hollybike/event/services/event/event_repository.dart';
import 'package:hollybike/positions/bloc/my_position_event.dart';
import 'package:hollybike/positions/bloc/my_position_state.dart';
import 'package:hollybike/positions/service/my_position_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/my_position_repository.dart';

class MyPositionBloc extends Bloc<MyPositionEvent, MyPositionState> {
  final EventRepository eventRepository;
  final MyPositionLocator myPositionLocator;

  ReceivePort port = ReceivePort();

  MyPositionBloc({
    required this.eventRepository,
    required this.myPositionLocator,
  }) : super(MyPositionInitial()) {
    on<SubscribeToMyPositionUpdates>(_onSubscribeToPositionUpdates);
    on<EnableSendPosition>(_onListenAndSendUserPosition);
    on<DisableSendPositions>(_onDisableSendPositions);

    if (IsolateNameServer.lookupPortByName(
            MyPositionServiceRepository.isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(
        MyPositionServiceRepository.isolateName,
      );
    }

    IsolateNameServer.registerPortWithName(
      port.sendPort,
      MyPositionServiceRepository.isolateName,
    );

    initPlatformState();
  }

  void _onSubscribeToPositionUpdates(
    SubscribeToMyPositionUpdates event,
    Emitter<MyPositionState> emit,
  ) async {
    emit(MyPositionLoading(state));

    final prefs = await SharedPreferences.getInstance();
    final eventId = prefs.getInt('tracking_event_id');

    final isRunning = await BackgroundLocator.isServiceRunning();

    emit(MyPositionInitialized(state.copyWith(
      isRunning: isRunning,
      eventId: isRunning ? eventId : null,
    )));

    port.listen((dynamic data) => eventRepository.onUserPositionSent());
  }

  Future<void> initPlatformState() async {
    log('Initializing Background Locator...');
    await BackgroundLocator.initialize();
    log('Background Locator initialization done');
  }

  void _onListenAndSendUserPosition(
    EnableSendPosition event,
    Emitter<MyPositionState> emit,
  ) async {
    emit(MyPositionLoading(state));

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt('tracking_event_id', event.eventId);

    if (state.isRunning) {
      await BackgroundLocator.unRegisterLocationUpdate();
    }

    try {
      await myPositionLocator.start(event.eventId, event.eventName);
    } catch (e) {
      emit(MyPositionFailure(
        state.copyWith(
          isRunning: false,
          status: MyPositionStatus.error,
          eventId: event.eventId,
        ),
        "Impossible de démarrer le suivi de la position",
      ));
      return;
    }

    final running = await BackgroundLocator.isServiceRunning();

    emit(MyPositionStarted(state.copyWith(
      isRunning: running,
      status: running ? MyPositionStatus.success : MyPositionStatus.error,
      eventId: event.eventId,
    )));
  }

  void _onDisableSendPositions(
    DisableSendPositions event,
    Emitter<MyPositionState> emit,
  ) async {
    emit(MyPositionLoading(state));

    await BackgroundLocator.unRegisterLocationUpdate();

    final running = await BackgroundLocator.isServiceRunning();

    emit(MyPositionStopped(state.copyWith(
      isRunning: running,
      status: running ? MyPositionStatus.error : MyPositionStatus.success,
    )));
  }
}
