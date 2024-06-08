import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:hollybike/shared/utils/waiter.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapPreview extends StatefulWidget {
  const MapPreview({super.key});

  @override
  State<MapPreview> createState() => _MapPreviewState();
}

class _MapPreviewState extends State<MapPreview> {
  bool _mapLoading = true;

  @override
  Widget build(BuildContext context) {
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
  }

  void _onMapCreated(MapboxMap map) {
    waitConcurrently(
      map.loadStyleURI("mapbox://styles/mapbox/navigation-night-v1"),
      rootBundle.loadString('assets/images/test.geojson'),
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
          AmbientLight(id: 'ambient-light', intensity: 0.5),
          DirectionalLight(
            castShadows: true,
            shadowIntensity: 1,
            id: 'directional-light',
            intensity: 0.5,
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

      await map.easeTo(
          CameraOptions(
            center: cameraOptions.center,
            zoom: cameraOptions.zoom! + 0.3,
            bearing: cameraOptions.bearing,
            pitch: cameraOptions.pitch,
          ),
          MapAnimationOptions(
            duration: 600,
          )
      );
    });
  }
}
