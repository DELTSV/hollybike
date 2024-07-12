import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/types/json_map.dart';
import '../websocket_message.dart';

part 'websocket_removed_from_event.freezed.dart';
part 'websocket_removed_from_event.g.dart';

@freezed
class WebsocketRemovedFromEvent
    with _$WebsocketRemovedFromEvent
    implements WebsocketBody {
  const factory WebsocketRemovedFromEvent({
    @Default("RemovedFromEventNotification") String type,
    @JsonKey(name: 'notification_id') required int notificationId,
    required int id,
    required String name,
  }) = _WebsocketRemovedFromEvent;

  factory WebsocketRemovedFromEvent.fromJson(JsonMap json) =>
      _$WebsocketRemovedFromEventFromJson(json);
}
