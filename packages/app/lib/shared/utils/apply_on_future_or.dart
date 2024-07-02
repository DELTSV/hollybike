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
