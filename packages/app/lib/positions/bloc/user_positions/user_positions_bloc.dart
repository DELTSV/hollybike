import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/auth/services/auth_persistence.dart';
import 'package:hollybike/positions/bloc/user_positions/user_positions_state.dart';
import 'package:hollybike/shared/websocket/recieve/websocket_receive_position.dart';
import 'package:hollybike/shared/websocket/recieve/websocket_subscribed.dart';
import 'package:hollybike/shared/websocket/websocket_client.dart';
import 'package:hollybike/shared/websocket/websocket_message.dart';
import 'package:http/http.dart';

import '../../../auth/types/auth_session.dart';
import '../../../profile/services/profile_repository.dart';
import '../../../user/types/minimal_user.dart';

part 'events/user_load_event.dart';
part 'events/user_picture_load_event.dart';
part 'events/user_positions_event.dart';

class UserPositionsBloc extends Bloc<UserPositionsEvent, UserPositionsState> {
  final AuthPersistence authPersistence;
  final ProfileRepository profileRepository;

  UserPositionsBloc({
    required this.authPersistence,
    required this.profileRepository,
    AuthSession? currentSession,
  }) : super(UserPositionsInitial()) {
    on<SubscribeToUserPositions>(_onSubscribeToUserPositions);
    on<UserLoadEvent>(_onUserLoadEvent);
    on<UserLoadSuccessEvent>(_onUserSuccessLoadEvent);
    on<UserPictureLoadEvent>(_onUserPictureLoadEvent);
  }

  UserLoadEvent? getPositionUser(WebsocketReceivePosition position) {
    try {
      return state.usersLoadEvent
          .firstWhere((user) => user.id == position.userId);
    } catch (_) {
      return null;
    }
  }

  UserPictureLoadEvent? getUserPicture(UserLoadSuccessEvent user) {
    final profilePicture = user.user.profilePicture;
    if(profilePicture == null) return null;

    try {
      return state.usersPicturesLoadEvent
          .firstWhere((picture) => picture.picturePath == profilePicture);
    } catch (_) {
      return null;
    }
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
          final newPositions = _replaceUserPosition(
            state.userPositions,
            message.data as WebsocketReceivePosition,
          );
          _updateUsersProfiles(newPositions);
          return UserPositionsUpdated(state, newPositions);
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

  void _updateUsersProfiles(
    List<WebsocketReceivePosition> userPositions,
  ) async {
    final currentSession = await authPersistence.currentSession;
    if (currentSession == null) return;

    final missingProfiles = userPositions.where(
      (userPosition) => !state.usersLoadEvent.any((loadEvent) =>
          loadEvent.id == userPosition.userId &&
          loadEvent.observerSession == currentSession),
    );

    for (var position in missingProfiles) {
      final futureOrUser = profileRepository.getUserById(
        position.userId,
        currentSession,
      );

      if (futureOrUser is Future<MinimalUser>) {
        futureOrUser.then(
          (user) {
            add(
              UserLoadSuccessEvent(
                observerSession: currentSession,
                id: position.userId,
                user: user,
              ),
            );
          },
          onError: (error) {
            add(
              UserLoadErrorEvent(
                observerSession: currentSession,
                id: position.userId,
                error: error,
              ),
            );
          },
        );
        add(
          UserLoadingEvent(
            observerSession: currentSession,
            id: position.userId,
          ),
        );
      } else {
        add(
          UserLoadSuccessEvent(
            observerSession: currentSession,
            id: position.userId,
            user: futureOrUser,
          ),
        );
      }
    }
  }

  void _onUserLoadEvent(
    UserLoadEvent event,
    Emitter<UserPositionsState> emit,
  ) {
    emit(UserProfilesUpdated(state, event));
  }

  void _onUserSuccessLoadEvent(
    UserLoadSuccessEvent event,
    Emitter<UserPositionsState> emit,
  ) {
    final picturePath = event.user.profilePicture;
    if (picturePath == null ||
        state.usersPicturesLoadEvent
            .any((picture) => picture.picturePath == picturePath)) return;

    get(Uri.parse(picturePath)).then(
      (response) {
        add(UserPictureLoadSuccessEvent(picturePath: picturePath, image: response.bodyBytes));
      },
      onError: (error) {
        add(UserPictureLoadErrorEvent(picturePath: picturePath, error: error));
      },
    );
    add(UserPictureLoadingEvent(picturePath: picturePath));
  }

  void _onUserPictureLoadEvent(
    UserPictureLoadEvent event,
    Emitter<UserPositionsState> emit,
  ) {
    emit(UserPicturesUpdated(state, event));
  }
}
