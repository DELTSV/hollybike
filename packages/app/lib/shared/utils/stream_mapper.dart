import 'package:rxdart/rxdart.dart';

class StreamMapper<T> {
  final _streamControllerMap = <int, BehaviorSubject<T>>{};
  final _streamListenerCountMap = <int, int>{};

  final T seedValue;

  StreamMapper({required this.seedValue});

  Stream<T> stream(int key) =>
      _streamControllerMap
          .putIfAbsent(
        key,
            () => BehaviorSubject<T>.seeded(seedValue),
      )
          .stream
          .doOnListen(
            () {
          _streamListenerCountMap[key] =
          _streamListenerCountMap[key] == null
              ? 1
              : _streamListenerCountMap[key]! + 1;
        },
      ).doOnCancel(() {
        if (_streamListenerCountMap[key] == null) {
          return;
        }

        _streamListenerCountMap[key] =
            _streamListenerCountMap[key]! - 1;

        if (_streamListenerCountMap[key] == 0) {
          _streamControllerMap[key]?.close();
          _streamControllerMap.remove(key);
          _streamListenerCountMap.remove(key);
        }
      });

  void add(int key, T value) => _streamControllerMap[key]?.add(value);

  T? get(int key) => _streamControllerMap[key]?.value;

  bool containsKey(int key) => _streamControllerMap.containsKey(key);

  List<BehaviorSubject<T>> get values => _streamControllerMap.values.toList();
}