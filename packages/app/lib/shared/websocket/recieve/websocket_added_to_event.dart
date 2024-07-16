/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/types/json_map.dart';
import '../websocket_message.dart';

part 'websocket_added_to_event.freezed.dart';
part 'websocket_added_to_event.g.dart';

@freezed
class WebsocketAddedToEvent
    with _$WebsocketAddedToEvent
    implements WebsocketBody {
  const factory WebsocketAddedToEvent({
    @Default("AddedToEventNotification") String type,
    @JsonKey(name: 'notification_id') required int notificationId,
    required int id,
    required String name,
  }) = _WebsocketAddedToEvent;

  factory WebsocketAddedToEvent.fromJson(JsonMap json) =>
      _$WebsocketAddedToEventFromJson(json);
}
