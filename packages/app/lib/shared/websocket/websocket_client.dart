import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/shared/websocket/recieve/websocket_added_to_event.dart';
import 'package:hollybike/shared/websocket/recieve/websocket_event_deleted.dart';
import 'package:hollybike/shared/websocket/recieve/websocket_event_published.dart';
import 'package:hollybike/shared/websocket/recieve/websocket_event_status_updated.dart';
import 'package:hollybike/shared/websocket/recieve/websocket_event_updated.dart';
import 'package:hollybike/shared/websocket/recieve/websocket_removed_from_event.dart';
import 'package:hollybike/shared/websocket/send/websocket_read_notification.dart';
import 'package:hollybike/shared/websocket/send/websocket_stop_send_position.dart';
import 'package:hollybike/shared/websocket/websocket_message.dart';

import 'recieve/websocket_error.dart';
import 'recieve/websocket_receive_position.dart';
import 'recieve/websocket_stop_receive_position.dart';
import 'recieve/websocket_subscribed.dart';
import 'send/websocket_send_position.dart';
import 'send/websocket_subscribe.dart';

class WebsocketClient {
  final AuthSession session;

  WebSocket? _client;

  WebsocketClient({required this.session});

  Future<WebsocketClient> connect() async {
    math.Random r = math.Random();
    String key = base64.encode(List<int>.generate(8, (_) => r.nextInt(256)));

    HttpClient client = HttpClient();
    HttpClientRequest request = await client.getUrl(
      Uri.parse('${session.host}/api/connect'),
    );
    request.headers.add('Connection', 'upgrade');
    request.headers.add('Upgrade', 'websocket');
    request.headers.add('sec-websocket-version', '13');
    request.headers.add('sec-websocket-key', key);

    HttpClientResponse response = await request.close();
    Socket socket = await response.detachSocket();

    final ws = WebSocket.fromUpgradedSocket(
      socket,
      serverSide: false,
    );

    _client = ws;

    return this;
  }

  void pingInterval(int seconds) {
    _client?.pingInterval = Duration(seconds: seconds);
  }

  void onDisconnect(void Function() onDisconnect) {
    _client?.done.then((_) {
      onDisconnect();
    });
  }

  void _send(String message) {
    if (_client == null) {
      log('Trying to send message to a closed connection.');
      return;
    }

    log('Sending message: $message', name: 'WebsocketClient._send');

    _client?.add(message);
  }

  void close() {
    _client?.close();
  }

  WebsocketMessage parseMessage(String data) {
    return WebsocketMessage.fromJson(jsonDecode(data), (json) {
      switch (json['type']) {
        case 'subscribed':
          return WebsocketSubscribed.fromJson(json);
        case 'receive-user-position':
          return WebsocketReceivePosition.fromJson(json);
        case 'stop-receive-user-position':
          return WebsocketStopReceivePosition.fromJson(json);
        case 'EventStatusUpdateNotification':
          return WebsocketEventStatusUpdated.fromJson(json);
        case 'AddedToEventNotification':
          return WebsocketAddedToEvent.fromJson(json);
        case 'RemovedFromEventNotification':
          return WebsocketRemovedFromEvent.fromJson(json);
        case 'DeleteEventNotification':
          return WebsocketEventDeleted.fromJson(json);
        case 'UpdateEventNotification':
          return WebsocketEventUpdated.fromJson(json);
        case 'NewEventNotification':
          return WebsocketEventPublished.fromJson(json);
        case 'error':
          return WebsocketError.fromJson(json);
      }

      throw Exception('Unknown message type: ${json['type']}');
    });
  }

  Stream<WebsocketMessage>? get stream {
    final stream = _client?.asBroadcastStream().map((event) {
      try {
        log('Received message: $event', name: 'WebsocketClient.stream');
        return parseMessage(event);
      } catch (e) {
        log('Error parsing message: $e', name: 'WebsocketClient.stream');
        return null;
      }
    });

    return stream?.where((event) => event != null).cast<WebsocketMessage>();
  }

  bool get isConnected => _client != null;

  void listen(void Function(WebsocketMessage) onData) {
    _client?.listen((data) {
      try {
        log('Received message: $data', name: 'WebsocketClient.listen');
        onData(parseMessage(data));
      } catch (e) {
        log('Error parsing message: $e', name: 'WebsocketClient.listen');
      }
    });
  }

  void subscribe(String channel) {
    log(
      'Subscribing to channel: $channel',
      name: 'WebsocketClient.subscribe',
    );

    final message = WebsocketMessage(
      channel: channel,
      data: WebsocketSubscribe(token: session.token),
    );

    final jsonObject = message.toJson(
      (obj) => (obj as WebsocketSubscribe).toJson(),
    );

    final jsonString = jsonEncode(jsonObject);

    _send(jsonString);
  }

  void sendUserPosition(String channel, WebsocketSendPosition position) {
    log(
      'Sending user position: ${position.latitude}, ${position.longitude}, ${position.altitude}, ${position.time}, ${position.speed}',
      name: 'WebsocketClient.sendUserPosition',
    );

    final message = WebsocketMessage(
      channel: channel,
      data: position,
    );

    final jsonObject = message.toJson(
      (obj) => (obj as WebsocketSendPosition).toJson(),
    );

    final jsonString = jsonEncode(jsonObject);

    _send(jsonString);
  }

  void sendReadNotification(String channel, int notificationId) {
    log(
      'Sending read notification',
      name: 'WebsocketClient.sendReadNotification',
    );

    final message = WebsocketMessage(
      channel: channel,
      data: WebsocketReadNotification(notificationId: notificationId),
    );

    final jsonObject = message.toJson(
      (obj) => (obj as WebsocketReadNotification).toJson(),
    );

    final jsonString = jsonEncode(jsonObject);

    _send(jsonString);
  }

  void stopSendPositions(String channel) {
    log(
      'Stop sending user position',
      name: 'WebsocketClient.stopSendPositions',
    );

    final message = WebsocketMessage(
      channel: channel,
      data: const WebsocketStopSendPosition(),
    );

    final jsonObject = message.toJson(
      (obj) => (obj as WebsocketStopSendPosition).toJson(),
    );

    final jsonString = jsonEncode(jsonObject);

    _send(jsonString);
  }
}
