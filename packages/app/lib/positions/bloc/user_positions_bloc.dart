import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/positions/bloc/user_positions_event.dart';
import 'package:hollybike/positions/bloc/user_positions_state.dart';
import 'package:hollybike/positions/types/recieve/websocket_receive_position.dart';
import 'package:hollybike/positions/types/websocket_message.dart';

import '../../auth/services/auth_persistence.dart';
import '../../auth/types/auth_session.dart';
import '../types/recieve/websocket_subscribed.dart';
import '../types/websocket_client.dart';

class UserPositionsBloc extends Bloc<UserPositionsEvent, UserPositionsState> {
  final AuthPersistence authPersistence;

  UserPositionsBloc({
    required this.authPersistence,
  }) : super(UserPositionsInitial()) {
    on<SubscribeToUserPositions>(_onSubscribeToUserPositions);
  }

  void _onSubscribeToUserPositions(
    SubscribeToUserPositions event,
    Emitter<UserPositionsState> emit,
  ) async {
    emit(UserPositionsLoading(state));

    final currentSession = await authPersistence.currentSession;

    if (currentSession == null) {
      emit(UserPositionsError(state, 'Error: No session'));
      return;
    }

    final stream = await _listenAndSubscribe(
      currentSession.host,
      currentSession.token,
      event.eventId,
    );

    await emit.forEach(stream, onData: (message) {
      switch (message.data.type) {
        case 'subscribed':
          final subscribed = message.data as WebsocketSubscribed;

          if (subscribed.subscribed) {
            return UserPositionsInitialized(state);
          }

          return UserPositionsError(state, 'Error: Not subscribed');
        case 'receive-user-position':
          return UserPositionsUpdated(
              state,
              _replaceUserPosition(
                state.userPositions,
                message.data as WebsocketReceivePosition,
              ));
        default:
          return UserPositionsError(state, 'Error: Unknown message type');
      }
    });
  }

  Future<Stream<WebsocketMessage>> _listenAndSubscribe(
    String host,
    String accessToken,
    int eventId,
  ) async {
    final ws = await WebsocketClient(
      session: AuthSession(
        token: accessToken,
        host: host,
        deviceId: '',
        refreshToken: '',
      ),
    ).connect();

    ws.onDisconnect(() {
      log('Websocket Disconnected');
    });

    ws.subscribe('event/$eventId');

    final stream = ws.stream;

    if (stream == null) {
      throw Exception('Error while listening to websocket');
    }

    return stream;
  }

  List<WebsocketReceivePosition> _replaceUserPosition(
    List<WebsocketReceivePosition> userPositions,
    WebsocketReceivePosition position,
  ) {
    final index = userPositions.indexWhere(
      (element) => element.userId == position.userId,
    );

    if (index == -1) {
      return [...userPositions, position];
    }

    final updatedPositions = List<WebsocketReceivePosition>.from(userPositions);
    updatedPositions[index] = position;

    return updatedPositions;
  }
}
