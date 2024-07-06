import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/types/json_map.dart';
import '../websocket_message.dart';

part 'websocket_error.freezed.dart';
part 'websocket_error.g.dart';

@freezed
class WebsocketError with _$WebsocketError implements WebsocketBody {
  const factory WebsocketError({
    required String message,
    @Default("subscribed") String type,
  }) = _WebsocketError;

  factory WebsocketError.fromJson(JsonMap json) =>
      _$WebsocketErrorFromJson(json);
}
