import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hollybike/auth/services/auth_persistence.dart';
import 'package:hollybike/auth/services/auth_repository.dart';
import 'package:hollybike/shared/websocket/recieve/websocket_error.dart';
import 'package:hollybike/shared/websocket/recieve/websocket_subscribed.dart';
import 'package:hollybike/shared/websocket/websocket_client.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../auth/types/auth_session.dart';

part 'notification_event.dart';

part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final AuthRepository authRepository;
  FlutterBackgroundService? service;

  void Function(FlutterBackgroundService)? onInitialized;

  NotificationBloc({required this.authRepository})
      : super(NotificationInitial()) {
    on<InitNotificationService>(_onInitNotificationService);

    initializeService().then((service) {
      service.on('stopService').listen((event) {
        this.service = null;
      });

      if (onInitialized != null) {
        onInitialized?.call(service);
        onInitialized = null;
      }

      this.service = service;
    });
  }

  void _onInitNotificationService(
    InitNotificationService event,
    Emitter<NotificationState> emit,
  ) async {
    final currentSession = await authRepository.currentSession;

    if (currentSession == null) {
      return;
    }

    connect(FlutterBackgroundService service) async {
      await Permission.notification.request();

      service.invoke("connect", {
        "token": currentSession.token,
        "host": currentSession.host,
      });
    }

    if (service == null) {
      onInitialized = connect;
      return;
    }

    connect(service!);
  }

  Future<FlutterBackgroundService> initializeService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: false,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: (service) => false,
      ),
    );

    await service.startService();

    return service;
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('background');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    WebsocketClient? webSocket;

    void showNotification(String message) async {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      );
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        'New Message',
        message,
        platformChannelSpecifics,
        payload: 'item x',
      );
    }

    Future<void> connectWebSocket(String token, String host) async {
      webSocket?.close();

      webSocket = WebsocketClient(
        session: AuthSession(
          token: token,
          host: host,
          refreshToken: '',
          deviceId: '',
        ),
      );

      await webSocket?.connect();

      webSocket?.subscribe('notification');

      webSocket?.listen((message) {
        switch (message.data.type) {
          case 'error':
            showNotification((message.data as WebsocketError).message);
            break;
          case 'subscribed':
            final WebsocketSubscribed subscribed =
                message.data as WebsocketSubscribed;
            showNotification("Subscribed: ${subscribed.subscribed}");
          default:
            showNotification("Message ${message.data.type}");
        }
      });
    }

    service.on('connect').listen((event) {
      final token = event?['token'] as String;
      final host = event?['host'] as String;

      connectWebSocket(token, host);
    });

    service.on('stopService').listen((event) {
      webSocket?.close();
      service.stopSelf();
    });

    final currentSession = await AuthPersistence().currentSession;

    if (currentSession != null) {
      connectWebSocket(currentSession.token, currentSession.host);
    }
  }
}
