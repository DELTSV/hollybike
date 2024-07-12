import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/shared/types/json_map.dart';
import 'package:hollybike/shared/websocket/websocket_message.dart';

part 'websocket_read_notification.freezed.dart';

part 'websocket_read_notification.g.dart';

@freezed
class WebsocketReadNotification
    with _$WebsocketReadNotification
    implements WebsocketBody {
  const factory WebsocketReadNotification({
    @Default("read-notification") String type,
    @JsonKey(name: 'notification') required int notificationId,
  }) = _WebsocketReadNotification;

  factory WebsocketReadNotification.fromJson(JsonMap json) =>
      _$WebsocketReadNotificationFromJson(json);
}
