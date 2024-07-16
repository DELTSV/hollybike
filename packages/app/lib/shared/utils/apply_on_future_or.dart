/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:async';

extension ApplyOnFutureOr<T> on FutureOr<T> {
  void apply(void Function(T) callback) async {
    if (this is Future<T>) {
      callback(await this);
      return;
    }
    callback(this as T);
  }
}
