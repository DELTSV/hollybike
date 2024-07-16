/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/journey/service/journey_position_manager.dart';
import 'package:hollybike/journey/type/minimal_journey.dart';
import 'package:hollybike/positions/bloc/user_positions/user_positions_bloc.dart';
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
          (pointManager) async {
            final journeyPositionManager = JourneyPositionManager(
              pointManager: pointManager,
              context: context,
            );
            final userPositionsBloc = BlocProvider.of<UserPositionsBloc>(
              context,
            );

            Timer(const Duration(seconds: 1), () {
              journeyPositionManager.updatePositions(userPositionsBloc.state.userPositions);

              userPositionsBloc.stream.listen(
                    (state) {
                  journeyPositionManager.updatePositions(state.userPositions);
                  _setCameraOptions(
                    geoJsonRaw,
                    state.userPositions,
                    map,
                    updateMode: true,
                  );
                },
              );
            });
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
          zoom: (cameraOptions.zoom ?? 0) + 0.9,
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
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
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
}
