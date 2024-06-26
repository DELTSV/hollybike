import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/positions/types/recieve/websocket_receive_position.dart';
import 'package:hollybike/positions/types/recieve/websocket_subscribed.dart';
import 'package:hollybike/positions/types/send/websocket_send_position.dart';
import 'package:hollybike/positions/types/send/websocket_subscribe.dart';
import 'package:hollybike/positions/types/websocket_message.dart';

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

  void onDisconnect(void Function() onDisconnect) {
    _client?.done.then((_) {
      onDisconnect();
    });
  }

  void _send(String message) {
    if (_client == null) {
      throw Exception('Websocket not connected');
    }

    log('Sending message: $message');

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
      }

      throw Exception('Unknown message type');
    });
  }

  Stream<WebsocketMessage>? get stream => _client
      ?.asBroadcastStream()
      .map((event) => parseMessage(event));

  bool get isConnected => _client != null;

  void listen(void Function(WebsocketMessage) onData) {
    _client?.listen((data) => onData(parseMessage(data)));
  }

  void subscribe(String channel) {
    log('Subscribing to channel: $channel');

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
        'Sending user position: ${position.latitude}, ${position.longitude}, ${position.altitude}, ${position.time}, ${position.speed}');

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
}
