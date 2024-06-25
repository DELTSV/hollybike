import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';

import '../../auth/types/auth_session.dart';
import '../types/recieve/websocket_subscribed.dart';
import '../types/send/websocket_send_position.dart';
import '../types/websocket_client.dart';

class MyPositionServiceRepository {
  static final MyPositionServiceRepository _instance =
      MyPositionServiceRepository._();

  MyPositionServiceRepository._();

  factory MyPositionServiceRepository() {
    return _instance;
  }

  static const String isolateName = 'LocatorIsolate';

  WebsocketClient? _client;
  String _channel = '';

  String _accessToken = '';
  String _host = '';
  double _eventId = -1;

  final _locationBuffer = <LocationDto>[];

  Future<void> init(Map<dynamic, dynamic> params) async {
    await initParams(params).catchError((e) {
      log('Error while init callback: $e', stackTrace: StackTrace.current);
      BackgroundLocator.unRegisterLocationUpdate();
    });

    final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(null);
  }

  Future<void> initParams(Map<dynamic, dynamic> params) async {
    if (!params.containsKey('accessToken') ||
        !params.containsKey('host') ||
        !params.containsKey('eventId')) {
      return Future.error('Missing parameters');
    }

    final accessToken = params['accessToken'] as String?;
    final host = params['host'] as String?;
    final eventId = params['eventId'] as double?;

    if (accessToken == null || host == null || eventId == null) {
      return Future.error('Missing parameters');
    }

    _accessToken = accessToken;
    _host = host;
    _eventId = eventId;

    _channel = 'event/${_eventId.toInt()}';

    await _listenAndSubscribe();
  }

  void retryConnection() {
    Future.delayed(const Duration(seconds: 10), () async {
      try {
        log('Retrying connection');
        await _listenAndSubscribe();
      } catch (e) {
        log('Error: $e', stackTrace: StackTrace.current);
        retryConnection(); // Retry again if an error occurs
      }
    });
  }

  Future<void> _listenAndSubscribe() async {
    final ws = await WebsocketClient(
      session: AuthSession(
        token: _accessToken,
        host: _host,
      ),
    ).connect();

    ws.onDisconnect(() {
      log('Websocket Disconnected');
      _client = null;

      retryConnection();
    });

    ws.listen((message) async {
      switch (message.data.type) {
        case 'subscribed':
          final subscribed = message.data as WebsocketSubscribed;

          if (subscribed.subscribed) {
            _client = ws;
            return;
          }

          throw Exception('Error: Not subscribed');
      }
    });

    ws.subscribe(_channel);
  }

  Future<void> dispose() async {
    final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(null);

    _client?.close();
  }

  Future<void> callback(LocationDto locationDto) async {
    if (_client == null) {
      _locationBuffer.add(locationDto);
      return;
    }

    if (_locationBuffer.isNotEmpty) {
      final buffer = List<LocationDto>.from(_locationBuffer);
      _locationBuffer.clear();

      for (final location in buffer) {
        _sendLocation(location);
      }
    }

    _sendLocation(locationDto);

    final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(locationDto.toJson());
  }

  void _sendLocation(LocationDto location) {
    _client?.sendUserPosition(
      _channel,
      WebsocketSendPosition(
        latitude: keepFiveDigits(location.latitude),
        longitude: keepFiveDigits(location.longitude),
        altitude: keepFiveDigits(location.altitude),
        time: timestampToDateTime(location.time),
        speed: keepFiveDigits(location.speed),
      ),
    );
  }
}

DateTime timestampToDateTime(double timestamp) {
  return DateTime.fromMillisecondsSinceEpoch(
    timestamp.toInt(),
    isUtc: false,
  ).toUtc();
}

double keepFiveDigits(double value) {
  return double.parse(value.toStringAsFixed(5));
}
