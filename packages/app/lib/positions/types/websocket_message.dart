import 'package:freezed_annotation/freezed_annotation.dart';

import '../../shared/types/json_map.dart';

part 'websocket_message.freezed.dart';
part 'websocket_message.g.dart';

abstract class WebsocketBody {
  final String type = '';
}

@Freezed(genericArgumentFactories: true)
class WebsocketMessage<T extends WebsocketBody> with _$WebsocketMessage {
  const factory WebsocketMessage({
    required String channel,
    required T data,
  }) = _WebsocketMessage;

  factory WebsocketMessage.fromJson(
    JsonMap json,
    T Function(JsonMap json) fromItemJson,
  ) =>
      _$WebsocketMessageFromJson(
        json,
        (Object? test) => fromItemJson(test as JsonMap),
      );
}
