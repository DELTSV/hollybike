/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/event/types/event_status_state.dart';

import '../../../shared/types/json_map.dart';
import '../websocket_message.dart';

part 'websocket_event_status_updated.freezed.dart';
part 'websocket_event_status_updated.g.dart';

@freezed
class WebsocketEventStatusUpdated
    with _$WebsocketEventStatusUpdated
    implements WebsocketBody {
  const factory WebsocketEventStatusUpdated({
    @Default("EventStatusUpdateNotification") String type,
    required int id,
    @JsonKey(name: 'notification_id') required int notificationId,
    required EventStatusState status,
    required String name,
    String? description,
    String? image,
  }) = _WebsocketEventStatusUpdated;

  factory WebsocketEventStatusUpdated.fromJson(JsonMap json) =>
      _$WebsocketEventStatusUpdatedFromJson(json);
}
