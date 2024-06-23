import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/websockets/types/websocket_message.dart';

import '../../shared/types/json_map.dart';

part 'websocket_position.freezed.dart';
part 'websocket_position.g.dart';

@freezed
class WebsocketPosition with _$WebsocketPosition implements WebsocketBody {
  const factory WebsocketPosition({
    @Default("send-user-position") String type,
    required double latitude,
    required double longitude,
    required double altitude,
    required DateTime time,
  }) = _WebsocketPosition;

  factory WebsocketPosition.fromJson(JsonMap json) => _$WebsocketPositionFromJson(json);
}