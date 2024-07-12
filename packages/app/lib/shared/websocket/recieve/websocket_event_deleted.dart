import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/types/json_map.dart';
import '../websocket_message.dart';

part 'websocket_event_deleted.freezed.dart';
part 'websocket_event_deleted.g.dart';

@freezed
class WebsocketEventDeleted
    with _$WebsocketEventDeleted
    implements WebsocketBody {
  const factory WebsocketEventDeleted({
    @Default("DeleteEventNotification") String type,
    @JsonKey(name: 'notification_id') required int notificationId,
    required String name,
    String? description,
  }) = _WebsocketEventDeleted;

  factory WebsocketEventDeleted.fromJson(JsonMap json) =>
      _$WebsocketEventDeletedFromJson(json);
}
