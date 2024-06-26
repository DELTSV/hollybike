import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/types/json_map.dart';
import '../websocket_message.dart';

part 'websocket_receive_position.freezed.dart';
part 'websocket_receive_position.g.dart';

@freezed
class WebsocketReceivePosition with _$WebsocketReceivePosition implements WebsocketBody {
  const factory WebsocketReceivePosition({
    required String type,
    required double latitude,
    required double longitude,
    required double altitude,
    required DateTime time,
    required double speed,
    @JsonKey(name: "user") required int userId,
  }) = _WebsocketReceivePosition;

  factory WebsocketReceivePosition.fromJson(JsonMap json) => _$WebsocketReceivePositionFromJson(json);
}