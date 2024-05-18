import 'dart:convert';

dynamic base64ToObject(String base64) {
  final suffix = base64.length % 4 == 0 ? "" : '=' * (4 - base64.length % 4);
  return jsonDecode(utf8.decode(base64Decode(base64 + suffix)));
}
