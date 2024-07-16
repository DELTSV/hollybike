/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/types/json_map.dart';
import '../websocket_message.dart';

part 'websocket_send_position.freezed.dart';
part 'websocket_send_position.g.dart';

@freezed
class WebsocketSendPosition
    with _$WebsocketSendPosition
    implements WebsocketBody {
  const factory WebsocketSendPosition({
    @Default("send-user-position") String type,
    required double latitude,
    required double longitude,
    required double altitude,
    required double heading,
    @JsonKey(name: "acceleration_x") required double accelerationX,
    @JsonKey(name: "acceleration_y") required double accelerationY,
    @JsonKey(name: "acceleration_z") required double accelerationZ,
    required DateTime time,
    required double speed,
    @JsonKey(name: "speed_accuracy") required double speedAccuracy,
    required double accuracy,
  }) = _WebsocketSendPosition;

  factory WebsocketSendPosition.fromJson(JsonMap json) =>
      _$WebsocketSendPositionFromJson(json);
}
