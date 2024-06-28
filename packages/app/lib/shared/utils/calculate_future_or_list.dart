import 'dart:async';

extension CalculateFutureOrList<T> on FutureOr<List<T>> {
  FutureOr<List<T>> add(FutureOr<T> item) async {
    final loadedItem = item is Future ? await item : item;
    return [
      loadedItem,
      ...(await this)
    ];
  }

  FutureOr<List<T>> operator -(FutureOr<T> item) async {
    final loadedItem = item is Future ? await item : item;
    return (await this).where((listItem) => listItem != loadedItem).toList();
  }
}
