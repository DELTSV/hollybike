/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/types/json_map.dart';
import '../websocket_message.dart';

part 'websocket_stop_receive_position.freezed.dart';
part 'websocket_stop_receive_position.g.dart';

@freezed
class WebsocketStopReceivePosition
    with _$WebsocketStopReceivePosition
    implements WebsocketBody {
  const factory WebsocketStopReceivePosition({
    required String type,
    @JsonKey(name: "user") required int userId,
  }) = _WebsocketStopReceivePosition;

  factory WebsocketStopReceivePosition.fromJson(JsonMap json) =>
      _$WebsocketStopReceivePositionFromJson(json);
}
