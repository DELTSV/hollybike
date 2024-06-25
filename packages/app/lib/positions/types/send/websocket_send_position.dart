import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/types/json_map.dart';
import '../websocket_message.dart';

part 'websocket_send_position.freezed.dart';
part 'websocket_send_position.g.dart';

@freezed
class WebsocketSendPosition with _$WebsocketSendPosition implements WebsocketBody {
  const factory WebsocketSendPosition({
    @Default("send-user-position") String type,
    required double latitude,
    required double longitude,
    required double altitude,
    required DateTime time,
    required double speed,
  }) = _WebsocketSendPosition;

  factory WebsocketSendPosition.fromJson(JsonMap json) => _$WebsocketSendPositionFromJson(json);
}