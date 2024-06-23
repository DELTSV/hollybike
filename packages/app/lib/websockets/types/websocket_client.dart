import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/websockets/types/recieve/websocket_subscribed.dart';
import 'package:hollybike/websockets/types/send/websocket_subscribe.dart';
import 'package:hollybike/websockets/types/websocket_message.dart';
import 'package:hollybike/websockets/types/send/websocket_send_position.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketClient {
  final AuthSession session;

  WebSocketChannel? _client;

  WebsocketClient({required this.session});

  Future<WebsocketClient> connect() async {
    Random r = Random();
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

    _client = IOWebSocketChannel(ws);

    return this;
  }

  void _send(String message) {
    if (_client == null) {
      throw Exception('Websocket not connected');
    }

    _client?.sink.add(message);
  }

  void close() {
    _client?.sink.close();
  }

  Stream<dynamic>? get stream => _client?.stream;

  bool get isConnected => _client != null;

  void listen(void Function(WebsocketMessage) onData) {
    _client?.stream.listen((data) {
      final message = WebsocketMessage.fromJson(jsonDecode(data), (json) {
        if (json['type'] == 'subscribed') {
          return WebsocketSubscribed.fromJson(json);
        } else if (json['type'] == 'receive-user-position') {
          return WebsocketSubscribe(
            token: session.token,
          );
        }

        throw Exception('Unknown message type');
      });

      onData(message);
    });
  }

  void subscribe(String channel) {
    print('Subscribing to channel: $channel');

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
    print('Sending user position: ${position.latitude}, ${position.longitude}, ${position.altitude}, ${position.time}');

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
