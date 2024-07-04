import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:hollybike/journey/type/minimal_journey.dart';
import 'package:hollybike/positions/bloc/user_positions_bloc.dart';
import 'package:hollybike/positions/bloc/user_positions_state.dart';
import 'package:hollybike/profile/bloc/profile_bloc.dart';
import 'package:hollybike/theme/bloc/theme_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../../positions/types/recieve/websocket_receive_position.dart';
import '../../../shared/utils/waiter.dart';

class JourneyMap extends StatefulWidget {
  final MinimalJourney journey;
  final void Function() onMapLoaded;

  const JourneyMap({
    super.key,
    required this.journey,
    required this.onMapLoaded,
  });

  @override
  State<JourneyMap> createState() => _JourneyMapState();
}

final init = WebsocketReceivePosition(
  type: "type",
  latitude: 48.61333,
  longitude: 2.2629,
  altitude: 0,
  time: DateTime.now(),
  speed: 20,
  userId: 90,
);
final then = WebsocketReceivePosition(
  type: "type",
  latitude: 48.61333,
  longitude: 2.2619,
  altitude: 0,
  time: DateTime.now(),
  speed: 20,
  userId: 90,
);

class _JourneyMapState extends State<JourneyMap> {
  bool _mapLoading = true;
  bool _mockPositionStep = false;

  @override
  Widget build(BuildContext context) {
    if (widget.journey.file == null) {
      return const Placeholder();
    }

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

  Future<String> _getGeoJsonData(String fileUrl) async {
    final response = await http.get(Uri.parse(fileUrl));
    return response.body;
  }

  void _onMapCreated(MapboxMap map) {
    final isDark = BlocProvider.of<ThemeBloc>(context).state.isDark;
    waitConcurrently(
      map.loadStyleURI(isDark
          ? "mapbox://styles/mapbox/navigation-night-v1"
          : "mapbox://styles/mapbox/navigation-day-v1"),
      _getGeoJsonData(widget.journey.file!),
    ).then((values) async {
      final (_, geoJsonRaw) = values;

      // map.style.addSource(
      //   RasterDemSource(
      //     id: 'mapbox-dem',
      //     url: 'mapbox://mapbox.mapbox-terrain-dem-v1',
      //     tileSize: 512,
      //   ),
      // );
      //
      // map.style.addLayer(
      //   HillshadeLayer(
      //     id: 'hillshade-layer',
      //     sourceId: 'mapbox-dem',
      //     hillshadeExaggeration: 1.5,
      //   ),
      // );
      //
      // map.style.setStyleTerrain('{ "source": "mapbox-dem", "exaggeration": 1.5 }');

      await Future.wait([
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
            _updateMapPositions(
              pointManager,
              userPositionsBloc.state,
            );
            userPositionsBloc.stream.listen(
              (state) => _updateMapPositions(
                pointManager,
                state,
              ),
            );
          },
        ),
      ]);

      final geoJson = GeoJSON.fromJSON(geoJsonRaw);

      if (geoJson.bbox == null) return;

      final bounds = CoordinateBounds(
        southwest: Point(
          coordinates: Position(
            geoJson.bbox![0],
            geoJson.bbox![1],
          ),
        ),
        northeast: Point(
          coordinates: Position(
            geoJson.bbox![2],
            geoJson.bbox![3],
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

      final cameraBounds = await map.coordinateBoundsForCamera(cameraOptions);

      await map.setBounds(
        CameraBoundsOptions(
          bounds: cameraBounds,
        ),
      );

      await map.setCamera(cameraOptions);

      setState(() {
        _mapLoading = false;
      });

      widget.onMapLoaded();

      await map.easeTo(
          CameraOptions(
            center: cameraOptions.center,
            zoom: cameraOptions.zoom! + 0.3,
            bearing: cameraOptions.bearing,
            pitch: cameraOptions.pitch,
          ),
          MapAnimationOptions(
            duration: 600,
          ));
    });
  }

  void _updateMapPositions(
    PointAnnotationManager pointManager,
    UserPositionsState userPositionsState,
  ) async {
    final profileBloc = BlocProvider.of<ProfileBloc>(context);
    final options = await Future.wait(
        userPositionsState.userPositions.map((position) async {
      final user = profileBloc.getProfileById(position.userId);
      final icon = await rootBundle
          .load("assets/images/placeholder_profile_picture.jpg");
      return PointAnnotationOptions(
        geometry: Point(
          coordinates: Position(
            position.longitude,
            position.latitude,
          ),
        ),
        image: icon.buffer.asUint8List(),
        iconSize: 0.3,
        iconAnchor: IconAnchor.BOTTOM,
        textAnchor: TextAnchor.TOP,
        textSize: 12,
        textField: user?.username,
        textHaloWidth: 2,
        textHaloColor: Theme.of(context).colorScheme.primary.value,
        textColor: Theme.of(context).colorScheme.onPrimary.value,
      );
    }).toList());

    await pointManager.deleteAll();
    await pointManager.createMulti(options);
  }
}
