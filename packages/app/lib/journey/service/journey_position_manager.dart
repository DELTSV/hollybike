/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/shared/websocket/recieve/websocket_receive_position.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../positions/bloc/user_positions/user_positions_bloc.dart';

class JourneyPositionManager {
  late final Map<int, PointAnnotation?> _points;
  late final List<int> _placeholderProfilePicture;
  final PointAnnotationManager pointManager;
  final BuildContext context;

  JourneyPositionManager({required this.pointManager, required this.context}) {
    _points = {};

    rootBundle
        .load(
      "assets/images/placeholder_map_pin.png",
    )
        .then(
      (ressource) {
        _placeholderProfilePicture = ressource.buffer.asUint8List();
      },
    );
  }

  void updatePositions(List<WebsocketReceivePosition> positions) async {
    final missingPositions = <WebsocketReceivePosition>[];
    final alreadyAddedPositions = <WebsocketReceivePosition>[];

    for (final position in positions) {
      if (_points.containsKey(position.userId) &&
          _points[position.userId] is PointAnnotation) {
        alreadyAddedPositions.add(position);
      } else {
        missingPositions.add(position);
      }
    }

    for (final userId in _points.keys) {
      if (!positions.any((p) => p.userId == userId)) {
        final point = _points[userId];
        if (point != null) {
          await pointManager.delete(point);
          _points[userId] = null;
        }
      }
    }

    await Future.wait(
      missingPositions.map((position) => _addMapPosition(position)),
    );

    await Future.wait(
      alreadyAddedPositions.map(
        (position) => _updateMapPosition(position),
      ),
    );

    for (final position in positions) {
      _updateTitles(position);
    }
  }

  Future<void> _addMapPosition(WebsocketReceivePosition missingPosition) async {
    final colorScheme = Theme.of(context).colorScheme;

    final user = BlocProvider.of<UserPositionsBloc>(context)
        .getPositionUser(missingPosition);
    if (user is! UserLoadSuccessEvent) return;

    final profilePicture =
        BlocProvider.of<UserPositionsBloc>(context).getUserPicture(user);
    if (user.user.profilePicture != null &&
        profilePicture is! UserPictureLoadSuccessEvent) return;

    final options = PointAnnotationOptions(
      geometry: Point(
        coordinates: Position(
          missingPosition.longitude,
          missingPosition.latitude,
        ),
      ),
      iconSize: profilePicture is UserPictureLoadSuccessEvent ? 0.390625 : 1,
      iconAnchor: IconAnchor.BOTTOM,
      textField: "",
      textAnchor: TextAnchor.TOP,
      textSize: 12,
      textHaloWidth: 2,
      textHaloColor: colorScheme.primary.value,
      textColor: colorScheme.onPrimary.value,
    );

    _points[missingPosition.userId] = await pointManager.create(options);
  }

  Future<void> _updateMapPosition(
    WebsocketReceivePosition positionToUpdate,
  ) async {
    final point = _points[positionToUpdate.userId];
    if (point == null) return;

    point.geometry.coordinates = Position(
      positionToUpdate.longitude,
      positionToUpdate.latitude,
    );

    await pointManager.update(point);
  }

  Future<void> _updateTitles(WebsocketReceivePosition position) async {
    final user =
        BlocProvider.of<UserPositionsBloc>(context).getPositionUser(position);
    if (user is! UserLoadSuccessEvent) return;

    final point = _points[user.user.id];
    if (point == null) return;

    final profilePicture =
        BlocProvider.of<UserPositionsBloc>(context).getUserPicture(user);
    if (user.user.profilePicture != null &&
        profilePicture is! UserPictureLoadSuccessEvent) return;

    point.textField =
        '${user.user.username}\n${(position.speed * 3.6).round()} km/h';
    point.image = (profilePicture is UserPictureLoadSuccessEvent
        ? profilePicture.image
        : _placeholderProfilePicture) as Uint8List;

    pointManager.update(point);
  }
}
