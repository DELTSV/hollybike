import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/shared/types/json_map.dart';
import 'package:hollybike/shared/websocket/websocket_message.dart';

part 'websocket_stop_send_position.freezed.dart';

part 'websocket_stop_send_position.g.dart';

@freezed
class WebsocketStopSendPosition
    with _$WebsocketStopSendPosition
    implements WebsocketBody {
  const factory WebsocketStopSendPosition({
    @Default("stop-send-user-position") String type,
  }) = _WebsocketStopSendPosition;

  factory WebsocketStopSendPosition.fromJson(JsonMap json) =>
      _$WebsocketStopSendPositionFromJson(json);
}
