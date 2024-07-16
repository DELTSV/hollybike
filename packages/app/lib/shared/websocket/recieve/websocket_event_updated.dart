/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/shared/types/json_map.dart';
import 'package:hollybike/shared/websocket/websocket_message.dart';

part 'websocket_event_updated.freezed.dart';
part 'websocket_event_updated.g.dart';

@freezed
class WebsocketEventUpdated
    with _$WebsocketEventUpdated
    implements WebsocketBody {
  const factory WebsocketEventUpdated({
    @Default("UpdateEventNotification") String type,
    @JsonKey(name: 'notification_id') required int notificationId,
    required int id,
    required String name,
    String? description,
    required DateTime start,
    String? image,
    @JsonKey(name: 'owner_id') required int ownerId,
    @JsonKey(name: 'owner_name') required String ownerName,
  }) = _WebsocketEventUpdated;

  factory WebsocketEventUpdated.fromJson(JsonMap json) =>
      _$WebsocketEventUpdatedFromJson(json);
}
