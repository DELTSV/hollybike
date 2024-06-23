import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/websockets/types/websocket_message.dart';

import '../../../shared/types/json_map.dart';

part 'websocket_subscribed.freezed.dart';
part 'websocket_subscribed.g.dart';

@freezed
class WebsocketSubscribed with _$WebsocketSubscribed implements WebsocketBody {
  const factory WebsocketSubscribed({
    required bool subscribed,
    @Default("subscribed") String type,
  }) = _WebsocketSubscribed;

  factory WebsocketSubscribed.fromJson(JsonMap json) => _$WebsocketSubscribedFromJson(json);
}