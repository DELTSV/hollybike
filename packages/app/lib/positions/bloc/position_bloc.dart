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
import 'package:hollybike/positions/bloc/position_event.dart';
import 'package:hollybike/positions/bloc/position_state.dart';

import '../../auth/types/auth_session.dart';
import '../../websockets/types/recieve/websocket_subscribed.dart';
import '../../websockets/types/send/websocket_send_position.dart';
import '../../websockets/types/websocket_client.dart';

@pragma('vm:entry-point')
class LocationCallbackHandler {
  @pragma('vm:entry-point')
  static Future<void> initCallback(Map<dynamic, dynamic> params) async {
    LocationServiceRepository myLocationCallbackRepository =
        LocationServiceRepository();
    await myLocationCallbackRepository.init(params);
  }

  @pragma('vm:entry-point')
  static Future<void> disposeCallback() async {
    LocationServiceRepository myLocationCallbackRepository =
        LocationServiceRepository();
    await myLocationCallbackRepository.dispose();
  }

  @pragma('vm:entry-point')
  static Future<void> callback(LocationDto locationDto) async {
    LocationServiceRepository myLocationCallbackRepository =
        LocationServiceRepository();
    await myLocationCallbackRepository.callback(locationDto);
  }

  @pragma('vm:entry-point')
  static Future<void> notificationCallback() async {
    print('***notificationCallback');
  }
}

class PositionBloc extends Bloc<PositionEvent, PositionState> {
  ReceivePort port = ReceivePort();

  PositionBloc() : super(PositionInitial()) {
    on<SubscribeToPositionUpdates>(_onSubscribeToPositionUpdates);
    on<EnableSendPosition>(_onListenAndSendUserPosition);
    on<DisableSendPositions>(_onDisableSendPositions);

    if (IsolateNameServer.lookupPortByName(
            LocationServiceRepository.isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(
        LocationServiceRepository.isolateName,
      );
    }

    IsolateNameServer.registerPortWithName(
      port.sendPort,
      LocationServiceRepository.isolateName,
    );

    initPlatformState();
  }

  void _onSubscribeToPositionUpdates(
    SubscribeToPositionUpdates event,
    Emitter<PositionState> emit,
  ) async {
    emit(PositionInitialized(state.copyWith(
      isRunning: await BackgroundLocator.isServiceRunning(),
    )));

    await emit.forEach(
      port.asBroadcastStream(),
      onData: (data) {
        return PositionUpdated(
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

  Future<void> _startLocator(Map<String, dynamic> data, String eventName) async {
    return await BackgroundLocator.registerLocationUpdate(
      LocationCallbackHandler.callback,
      initCallback: LocationCallbackHandler.initCallback,
      initDataCallback: data,
      disposeCallback: LocationCallbackHandler.disposeCallback,
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
          notificationTapCallback: LocationCallbackHandler.notificationCallback,
        ),
      ),
    );
  }

  void _onListenAndSendUserPosition(
    EnableSendPosition event,
    Emitter<PositionState> emit,
  ) async {
    emit(PositionLoading(state));

    Map<String, dynamic> data = {
      'accessToken': event.session.token,
      'host': event.session.host,
      'eventId': event.eventId,
    };

    await _startLocator(data, event.eventName);

    final running = await BackgroundLocator.isServiceRunning();

    emit(PositionStarted(state.copyWith(
      isRunning: running,
      status: running ? PositionStatus.success : PositionStatus.error,
    )));
  }

  void _onDisableSendPositions(
    DisableSendPositions event,
    Emitter<PositionState> emit,
  ) async {
    emit(PositionLoading(state));

    await BackgroundLocator.unRegisterLocationUpdate();

    final running = await BackgroundLocator.isServiceRunning();

    emit(PositionStopped(state.copyWith(
      isRunning: running,
      status: running ? PositionStatus.error : PositionStatus.success,
    )));
  }
}

class LocationServiceRepository {
  static final LocationServiceRepository _instance =
      LocationServiceRepository._();

  LocationServiceRepository._();

  factory LocationServiceRepository() {
    return _instance;
  }

  static const String isolateName = 'LocatorIsolate';

  WebsocketClient? client;
  String channel = '';

  Future<void> init(Map<dynamic, dynamic> params) async {
    void onError() {
      final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
      send?.send(null);
    }

    if (!params.containsKey('accessToken') || !params.containsKey('host') || !params.containsKey('eventId')) {
      onError();
      return;
    }

    final accessToken = params['accessToken'] as String?;
    final host = params['host'] as String?;
    final eventId = params['eventId'] as double?;

    if (accessToken == null || host == null || eventId == null) {
      onError();
      return;
    }

    final ws = await WebsocketClient(
      session: AuthSession(
        token: accessToken,
        host: host,
      ),
    ).connect();

    channel = 'event/${eventId.toInt()}';

    try {
      ws.listen((message) async {
        switch (message.data.type) {
          case 'subscribed':
            final subscribed = message.data as WebsocketSubscribed;

            if (subscribed.subscribed) {
              client = ws;
              return;
            }

            throw Exception('Error: Not subscribed');
        }
      });
    } catch (e) {
      print('Error: $e');
    }

    ws.subscribe(channel);

    onError();
  }

  Future<void> dispose() async {
    print("***********Dispose callback handler");
    final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(null);
  }

  Future<void> callback(LocationDto locationDto) async {
    client?.sendUserPosition(
      channel,
      WebsocketSendPosition(
        latitude: keepFiveDigits(locationDto.latitude),
        longitude: keepFiveDigits(locationDto.longitude),
        altitude: keepFiveDigits(locationDto.altitude),
        time: DateTime.now().toUtc(),
      ),
    );

    final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(locationDto.toJson());
  }
}

double keepFiveDigits(double value) {
  return double.parse(value.toStringAsFixed(5));
}
