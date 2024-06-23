import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/websockets/types/websocket_message.dart';

import '../../shared/types/json_map.dart';

part 'websocket_subscribe.freezed.dart';
part 'websocket_subscribe.g.dart';

@freezed
class WebsocketSubscribe with _$WebsocketSubscribe implements WebsocketBody {
  const factory WebsocketSubscribe({
    required String token,
    @Default("subscribe") String type,
  }) = _WebsocketSubscribe;

  factory WebsocketSubscribe.fromJson(JsonMap json) => _$WebsocketSubscribeFromJson(json);
}