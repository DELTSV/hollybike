import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/websockets/types/websocket_message.dart';
import 'package:hollybike/websockets/types/websocket_position.dart';
import 'package:hollybike/websockets/types/websocket_subscribe.dart';
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

  void listen(void Function(dynamic) onData) {
    _client?.stream.listen(onData);
  }

  void subscribe(String channel) {
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

  void sendUserPosition(String channel, WebsocketPosition position) {
    final message = WebsocketMessage(
      channel: channel,
      data: position,
    );

    final jsonObject = message.toJson(
      (obj) => (obj as WebsocketPosition).toJson(),
    );

    final jsonString = jsonEncode(jsonObject);

    _send(jsonString);
  }
}
