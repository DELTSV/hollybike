import 'package:rxdart/rxdart.dart';

class StreamCounter<T> {
  final T seedValue;

  late final _streamController = BehaviorSubject<T>.seeded(seedValue);
  int _listenerCount = 0;

  StreamCounter(this.seedValue);

  Stream<T> get stream => _streamController.stream.doOnListen(() {
    _listenerCount++;
  }).doOnCancel(() {
    _listenerCount--;
    if (_listenerCount == 0) {
      _streamController.close();
    }
  });

  void add(T value) => _streamController.add(value);

  bool get isListening => _listenerCount > 0;

  T get value => _streamController.value;

  BehaviorSubject<T> get subject => _streamController;
}

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

  List<T> get values => _streamControllerMap.values.map((e) => e.value).toList();

  List<BehaviorSubject<T>> get subjects => _streamControllerMap.values.toList();

  List<int> get keys => _streamControllerMap.keys.toList();
}