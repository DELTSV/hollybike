import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/types/json_map.dart';
import '../websocket_message.dart';

part 'websocket_event_published.freezed.dart';
part 'websocket_event_published.g.dart';

@freezed
class WebsocketEventPublished
    with _$WebsocketEventPublished
    implements WebsocketBody {
  const factory WebsocketEventPublished({
    @Default("NewEventNotification") String type,
    @JsonKey(name: 'notification_id') required int notificationId,
    required int id,
    required String name,
    String? description,
    required DateTime start,
    String? image,
    @JsonKey(name: 'owner_id') required int ownerId,
    @JsonKey(name: 'owner_name') required String ownerName,
  }) = _WebsocketEventPublished;

  factory WebsocketEventPublished.fromJson(JsonMap json) =>
      _$WebsocketEventPublishedFromJson(json);
}
