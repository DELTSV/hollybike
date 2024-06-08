import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapPreview extends StatelessWidget {
  const MapPreview({super.key});

  void _onMapCreated(MapboxMap map) {
    map.loadStyleURI("mapbox://styles/mapbox/satellite-streets-v12").then((s) {
      map.style.addSource(
        RasterDemSource(
          id: 'mapbox-dem',
          url: 'mapbox://mapbox.mapbox-terrain-dem-v1',
          tileSize: 512,
        ),
      );

      map.style.addLayer(
        HillshadeLayer(
          id: 'hillshade-layer',
          sourceId: 'mapbox-dem',
          hillshadeExaggeration: 1.5,
        ),
      );

      map.style
          .setStyleTerrain('{ "source": "mapbox-dem", "exaggeration": 1.5 }');

      rootBundle.loadString('assets/images/tracks.geojson').then((string) {
        map.style.addSource(
          GeoJsonSource(
            id: 'tracks',
            data: string,
          ),
        );

        map.style.addLayer(
          LineLayer(
            id: 'tracks-layer',
            sourceId: 'tracks',
            lineJoin: LineJoin.BEVEL,
            lineCap: LineCap.ROUND,
            lineColor: 0xFF3BB2D0,
            lineWidth: 8,
          ),
        );
      });
    });

    map.setCamera(
      CameraOptions(
        zoom: 14,
        center: Point(coordinates: Position(-114.26608, 32.7213)),
        pitch: 30,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      mapOptions: MapOptions(
        constrainMode: ConstrainMode.WIDTH_AND_HEIGHT,
        size: Size(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        pixelRatio: MediaQuery.of(context).devicePixelRatio,
      ),
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(
          () => EagerGestureRecognizer(),
        ),
      },
      key: const ValueKey("mapWidget"),
      onMapCreated: _onMapCreated,
    );
  }
}
