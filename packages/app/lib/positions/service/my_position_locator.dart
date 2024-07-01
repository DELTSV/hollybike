import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/auth/bloc/auth_persistence.dart';

import 'my_position_handler.dart';

class MyPositionLocator {
  final AuthPersistence authPersistence;

  MyPositionLocator({required this.authPersistence});

  Future<void> start(int eventId, String eventName) async {

    final session = await authPersistence.currentSession;

    if (session == null) {
      throw Exception('No session found, cannot start location tracking');
    }

    Map<String, dynamic> data = {
      'accessToken': session.token,
      'host': session.host,
      'eventId': eventId,
    };

    return BackgroundLocator.registerLocationUpdate(
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
        distanceFilter: 1,
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
}