import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/positions/bloc/my_position_event.dart';
import 'package:hollybike/positions/bloc/my_position_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/my_position_handler.dart';
import '../service/my_position_repository.dart';

class MyPositionBloc extends Bloc<MyPositionEvent, MyPositionState> {
  ReceivePort port = ReceivePort();

  MyPositionBloc() : super(MyPositionInitial()) {
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
    final prefs = await SharedPreferences.getInstance();
    final eventId = prefs.getInt('tracking_event_id');

    final isRunning = await BackgroundLocator.isServiceRunning();

    emit(MyPositionInitialized(state.copyWith(
      isRunning: isRunning,
      eventId: isRunning ? eventId : null,
    )));

    await emit.forEach(
      port.asBroadcastStream(),
      onData: (data) {
        return MyPositionUpdated(
          state,
          data != null ? LocationDto.fromJson(data) : null,
        );
      },
    );
  }

  Future<void> initPlatformState() async {
    print('Initializing...');
    await BackgroundLocator.initialize();
    print('Initialization done');
  }

  Future<void> _startLocator(
      Map<String, dynamic> data, String eventName) async {
    return await BackgroundLocator.registerLocationUpdate(
      MyPositionCallbackHandler.callback,
      initCallback: MyPositionCallbackHandler.initCallback,
      initDataCallback: data,
      disposeCallback: MyPositionCallbackHandler.disposeCallback,
      iosSettings: const IOSSettings(
        accuracy: LocationAccuracy.NAVIGATION,
        distanceFilter: 0,
        stopWithTerminate: true,
      ),
      autoStop: false,
      androidSettings: AndroidSettings(
        accuracy: LocationAccuracy.NAVIGATION,
        interval: 1,
        distanceFilter: 0,
        client: LocationClient.google,
        androidNotificationSettings: AndroidNotificationSettings(
          notificationChannelName: 'location_tracking_channel',
          notificationTitle: 'Suivi de votre position',
          notificationMsg: 'Suivi de votre position en arrière-plan',
          notificationBigMsg:
              'Le suivi de votre position est activé afin de partager votre position en temps réel avec les autres participants de l\'événement "$eventName" ',
          notificationIconColor: Colors.grey,
          notificationTapCallback:
              MyPositionCallbackHandler.notificationCallback,
        ),
      ),
    );
  }

  void _onListenAndSendUserPosition(
    EnableSendPosition event,
    Emitter<MyPositionState> emit,
  ) async {
    emit(MyPositionLoading(state));

    Map<String, dynamic> data = {
      'accessToken': event.session.token,
      'host': event.session.host,
      'eventId': event.eventId,
    };

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt('tracking_event_id', event.eventId);

    if (state.isRunning) {
      await BackgroundLocator.unRegisterLocationUpdate();
    }

    await _startLocator(data, event.eventName);

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
