import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/shared/types/geojson.dart';
import 'package:hollybike/shared/utils/waiter.dart';
import 'package:hollybike/shared/widgets/bar/top_bar.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_action_icon.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_title.dart';
import 'package:hollybike/shared/widgets/hud/hud.dart';
import 'package:hollybike/theme/bloc/theme_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'package:http/http.dart' as http;

@RoutePage()
class UserJourneyMapScreen extends StatefulWidget {
  final String fileUrl;
  final String title;

  const UserJourneyMapScreen({
    super.key,
    required this.fileUrl,
    required this.title,
  });

  @override
  State<UserJourneyMapScreen> createState() => _UserJourneyMapScreenState();
}

class _UserJourneyMapScreenState extends State<UserJourneyMapScreen> {
  bool _mapLoading = true;
  bool _mapError = false;

  @override
  Widget build(BuildContext context) {
    return Hud(
      appBar: TopBar(
        prefix: TopBarActionIcon(
          icon: Icons.arrow_back,
          onPressed: () => context.router.maybePop(),
        ),
        title: TopBarTitle(widget.title),
      ),
      body: SizedBox(
        child: Builder(
          builder: (context) {
            if (_mapError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Erreur lors du chargement de la carte"),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.router.maybePop(),
                      child: const Text("Retour"),
                    ),
                  ],
                ),
              );
            }

            return Stack(
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
            );
          }),
        ),
      );
  }

  void _onMapCreated(MapboxMap map) {
    final isDark = BlocProvider.of<ThemeBloc>(context).state.isDark;
    waitConcurrently(
      map.loadStyleURI(isDark
          ? "mapbox://styles/mapbox/navigation-night-v1"
          : "mapbox://styles/mapbox/navigation-day-v1"),
      _getGeoJsonData(widget.fileUrl),
    ).then((values) async {
      final (_, geoJsonRaw) = values;

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
      ]);

      final bbox = GeoJSON.fromJsonString(geoJsonRaw).dynamicBBox();

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

      final cameraBounds = await map.coordinateBoundsForCamera(cameraOptions);

      await map.setBounds(
        CameraBoundsOptions(
          bounds: cameraBounds,
        ),
      );

      await map.setCamera(cameraOptions);

      await Future.delayed(const Duration(milliseconds: 100));

      setState(() {
        _mapLoading = false;
      });

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
    }).catchError((e) {
      log('Error while loading map', error: e);
      setState(() {
        _mapError = true;
      });
    });
  }

  Future<String> _getGeoJsonData(String fileUrl) async {
    final response = await http.get(Uri.parse(fileUrl));
    return response.body;
  }
}
