import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/positions/bloc/position_event.dart';
import 'package:hollybike/positions/bloc/position_state.dart';

class PositionBloc extends Bloc<PositionEvent, PositionState> {
  PositionBloc() : super(PositionInitial()) {
    on<ListenAndSendUserPosition>(_onListenAndSendUserPosition);
    on<DisableSendPositions>(_onDisableSendPositions);
  }

  void _onListenAndSendUserPosition(
    ListenAndSendUserPosition event,
    Emitter<PositionState> emit,
  ) async {
    // Map<String, dynamic> data = {
    //   'accessToken': event.session.token,
    //   'host': event.session.host,
    //   'eventId': event.eventId,
    // };

    print('ListenAndSendUserPosition');
  }

  void _onDisableSendPositions(
    DisableSendPositions event,
    Emitter<PositionState> emit,
  ) {
    print('DisableSendPositions');
    BackgroundLocator.unRegisterLocationUpdate();
  }
}
