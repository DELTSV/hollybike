import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/journey/type/minimal_journey.dart';
import 'package:hollybike/positions/bloc/user_positions/user_positions_bloc.dart';
import 'package:hollybike/positions/bloc/user_positions/user_positions_state.dart';
import 'package:hollybike/shared/types/geojson.dart';
import 'package:hollybike/shared/utils/waiter.dart';
import 'package:hollybike/shared/websocket/recieve/websocket_receive_position.dart';
import 'package:hollybike/theme/bloc/theme_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class JourneyMap extends StatefulWidget {
  final MinimalJourney? journey;
  final List<WebsocketReceivePosition> userPositions;
  final void Function() onMapLoaded;

  const JourneyMap({
    super.key,
    required this.journey,
    required this.userPositions,
    required this.onMapLoaded,
  });

  @override
  State<JourneyMap> createState() => _JourneyMapState();
}

class _JourneyMapState extends State<JourneyMap> {
  late final List<int> placeholderProfilePicture;
  Map<int, PointAnnotation> currentPositions = {};
  bool _mapLoading = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Stack(
        children: <Widget>[
          MapWidget(
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
            key: const ValueKey("mapWidget"),
            onMapCreated: _onMapCreated,
          ),
          AnimatedOpacity(
            opacity: _mapLoading ? 1 : 0,
            duration: const Duration(milliseconds: 500),
            child: IgnorePointer(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    rootBundle
        .load(
      "assets/images/placeholder_map_pin.png",
    )
        .then((ressource) {
      placeholderProfilePicture = ressource.buffer.asUint8List();
    });
  }

  Future<String> _getGeoJsonData(String fileUrl) async {
    final response = await http.get(Uri.parse(fileUrl));
    return response.body;
  }

  void _onMapCreated(MapboxMap map) {
    final isDark = BlocProvider.of<ThemeBloc>(context).state.isDark;
    final file = widget.journey?.file;

    waitConcurrently(
      map.loadStyleURI(isDark
          ? "mapbox://styles/mapbox/navigation-night-v1"
          : "mapbox://styles/mapbox/navigation-day-v1"),
      file == null ? Future.value(null) : _getGeoJsonData(file),
    ).then((values) async {
      final (_, geoJsonRaw) = values;
      setState(() {
        currentPositions = {};
      });

      await Future.wait([
        if (geoJsonRaw != null)
          map.style.addSource(
            GeoJsonSource(
              id: 'tracks',
              data: geoJsonRaw,
            ),
          ),
        map.style.setLights(
          AmbientLight(id: 'ambient-light', intensity: isDark ? 0.5 : 1),
          DirectionalLight(
            castShadows: true,
            shadowIntensity: 1,
            id: 'directional-light',
            intensity: isDark ? 0.5 : 1,
            color: 0XFFEC9F53,
            direction: [0, 90],
          ),
        ),
        map.style.addLayerAt(
            LineLayer(
              id: 'tracks-layer',
              sourceId: 'tracks',
              lineJoin: LineJoin.ROUND,
              lineCap: LineCap.ROUND,
              lineColor: 0xFF3457D5,
              lineWidth: 5,
              lineEmissiveStrength: 1,
            ),
            LayerPosition(
              above: 'traffic-bridge-road-link-navigation',
            )),
        map.style.addLayerAt(
          FillExtrusionLayer(
            id: '3d-buildings',
            sourceId: 'composite',
            sourceLayer: 'building',
            fillExtrusionOpacity: 0.8,
            fillExtrusionColor: 0XFF515E72,
          ),
          LayerPosition(
            above: 'tracks-layer',
          ),
        ),
        map.style.setStyleLayerProperty(
          "3d-buildings",
          "fill-extrusion-height",
          '[ "interpolate", ["linear"], ["zoom"], 15, 0, 15.05, ["get", "height"] ]',
        ),
        map.style.setStyleLayerProperty(
          "3d-buildings",
          "fill-extrusion-base",
          '[ "interpolate", ["linear"], ["zoom"], 15, 0, 15.05, ["get", "min_height"] ]',
        ),
        map.annotations.createPointAnnotationManager().then(
          (pointManager) {
            final userPositionsBloc =
                BlocProvider.of<UserPositionsBloc>(context);
            _updateMap(
              pointManager,
              userPositionsBloc.state,
            );
            userPositionsBloc.stream.listen(
              (state) {
                _updateMap(
                  pointManager,
                  state,
                );

                _setCameraOptions(
                  geoJsonRaw,
                  state.userPositions,
                  map,
                  updateMode: true,
                );
              },
            );
          },
        ),
      ]);

      final cameraOptions = await _setCameraOptions(
        geoJsonRaw,
        widget.userPositions,
        map,
      );

      setState(() {
        _mapLoading = false;
      });

      widget.onMapLoaded();

      await map.easeTo(
        CameraOptions(
          center: cameraOptions.center,
          zoom: (cameraOptions.zoom ?? 0) + 0.3,
          bearing: cameraOptions.bearing,
          pitch: cameraOptions.pitch,
        ),
        MapAnimationOptions(
          duration: 600,
        ),
      );
    });
  }

  Future<CameraOptions> _setCameraOptions(
    String? geoJsonRaw,
    List<WebsocketReceivePosition> userPositions,
    MapboxMap map, {
    bool updateMode = false,
  }) async {
    final userCoordinates = userPositions
        .map(
          (position) => Coordinate(
            longitude: position.longitude,
            latitude: position.latitude,
          ),
        )
        .toList();

    final bbox = geoJsonRaw == null
        ? GeoJSON.calculateBbox(userCoordinates)
        : GeoJSON.fromJsonString(geoJsonRaw).dynamicBBox(
            extraValues: userCoordinates,
          );

    final bounds = CoordinateBounds(
      southwest: Point(
        coordinates: Position(
          bbox[0],
          bbox[1],
        ),
      ),
      northeast: Point(
        coordinates: Position(
          bbox[2],
          bbox[3],
        ),
      ),
      infiniteBounds: false,
    );

    final cameraOptions = await map.cameraForCoordinateBounds(
      bounds,
      MbxEdgeInsets(
        top: 25,
        left: 50,
        right: 50,
        bottom: 75,
      ),
      null,
      30,
      null,
      null,
    );

    await map.setBounds(
      CameraBoundsOptions(
        bounds: bounds,
      ),
    );

    if (!updateMode) {
      await map.setCamera(cameraOptions);
    }

    return cameraOptions;
  }

  void _updateMap(
    PointAnnotationManager pointManager,
    UserPositionsState userPositionsState,
  ) async {
    final missingPositions = <WebsocketReceivePosition>[];
    final alreadyAddedPositions = <WebsocketReceivePosition>[];

    for (final position in userPositionsState.userPositions) {
      if (currentPositions.containsKey(position.userId)) {
        alreadyAddedPositions.add(position);
      } else {
        missingPositions.add(position);
      }
    }

    for (final userId in currentPositions.keys) {
      if (!userPositionsState.userPositions.any((p) => p.userId == userId)) {
        final point = currentPositions[userId];

        if (point != null) {
          await pointManager.delete(point);
        }
      }
    }

    final addedPositions = (await Future.wait(
      missingPositions
          .map((position) => _addMapPosition(pointManager, position)),
    ))
        .whereType<MapEntry<int, PointAnnotation>>();

    final updatedPositions = await Future.wait(
      alreadyAddedPositions
          .map((position) => _updateMapPosition(pointManager, position)),
    );

    setState(() {
      currentPositions = Map.fromEntries(
        [...addedPositions, ...updatedPositions],
      );
    });
  }

  Future<MapEntry<int, PointAnnotation>?> _addMapPosition(
    PointAnnotationManager pointManager,
    WebsocketReceivePosition missingPosition,
  ) async {
    final colorScheme = Theme.of(context).colorScheme;

    final user = BlocProvider.of<UserPositionsBloc>(context)
        .getPositionUser(missingPosition);
    if (user is! UserLoadSuccessEvent) return null;

    final profilePicture =
        BlocProvider.of<UserPositionsBloc>(context).getUserPicture(user);

    final options = PointAnnotationOptions(
      geometry: Point(
        coordinates: Position(
          missingPosition.longitude,
          missingPosition.latitude,
        ),
      ),
      image: (profilePicture is UserPictureLoadSuccessEvent
          ? profilePicture.image
          : placeholderProfilePicture) as Uint8List,
      iconAnchor: IconAnchor.BOTTOM,
      textField:
          '${user.user.username}\n${(missingPosition.speed * 3.6).round()} km/h',
      textAnchor: TextAnchor.TOP,
      textSize: 12,
      textHaloWidth: 2,
      textHaloColor: colorScheme.primary.value,
      textColor: colorScheme.onPrimary.value,
    );
    final point = await pointManager.create(options);

    return MapEntry(missingPosition.userId, point);
  }

  Future<MapEntry<int, PointAnnotation>> _updateMapPosition(
    PointAnnotationManager pointManager,
    WebsocketReceivePosition positionToUpdate,
  ) async {
    final point = currentPositions[positionToUpdate.userId];
    if (point == null) {
      throw Exception("Cannot find point for key $positionToUpdate");
    }

    point.geometry = Point(
      coordinates: Position(
        positionToUpdate.longitude,
        positionToUpdate.latitude,
      ),
    );

    final user = BlocProvider.of<UserPositionsBloc>(context)
        .getPositionUser(positionToUpdate);
    if (user is UserLoadSuccessEvent) {
      final profilePicture =
          BlocProvider.of<UserPositionsBloc>(context).getUserPicture(user);
      point.image = (profilePicture is UserPictureLoadSuccessEvent
          ? profilePicture.image
          : placeholderProfilePicture) as Uint8List;

      point.textField =
          '${user.user.username}\n${(positionToUpdate.speed * 3.6).round()} km/h';
    }

    await pointManager.update(point);
    return MapEntry(positionToUpdate.userId, point);
  }
}
