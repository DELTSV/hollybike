import 'package:hollybike/shared/types/paginated_list.dart';
import 'package:rxdart/rxdart.dart';

enum RefreshedType {
  none,
  refreshed,
  refreshedAndHasMore,
}

RefreshedType refreshedTypeFromPageResult(PaginatedList<dynamic> pageResult) {
  print('pageResult.page: ${pageResult.page}, pageResult.totalPages: ${pageResult.totalPages}');
  return pageResult.page < pageResult.totalPages - 1
      ? RefreshedType.refreshedAndHasMore
      : RefreshedType.refreshed;
}

class StreamValue<T> {
  final T value;
  final RefreshedType refreshed;

  StreamValue(this.value, {this.refreshed = RefreshedType.none});
}

class StreamCounter<T> {
  final T seedValue;
  final String name;

  BehaviorSubject<StreamValue<T>>? _streamController;
  int _listenerCount = 0;

  StreamCounter(this.seedValue, this.name);

  Stream<StreamValue<T>> get stream {
    _streamController ??= BehaviorSubject<StreamValue<T>>.seeded(
      StreamValue(seedValue),
    );

    return _streamController!.stream.doOnListen(() {
      _listenerCount++;
    }).doOnCancel(() {
      _listenerCount--;
      if (_listenerCount == 0) {
        _streamController?.close();
        _streamController = null;
      }
    });
  }

  void add(
    T value, {
    RefreshedType refreshing = RefreshedType.none,
  }) =>
      _streamController?.add(StreamValue(
        value,
        refreshed: refreshing,
      ));

  bool get isListening => _listenerCount > 0;

  T get value => _streamController?.value.value ?? seedValue;

  BehaviorSubject<StreamValue<T>>? get subject => _streamController;
}

class StreamMapper<T> {
  final _streamControllerMap = <int, BehaviorSubject<StreamValue<T>>>{};
  final _streamListenerCountMap = <int, int>{};

  final T seedValue;

  StreamMapper({required this.seedValue});

  Stream<StreamValue<T>> stream(int key) => _streamControllerMap
          .putIfAbsent(
            key,
            () =>
                BehaviorSubject<StreamValue<T>>.seeded(StreamValue(seedValue)),
          )
          .stream
          .doOnListen(
        () {
          _streamListenerCountMap[key] = _streamListenerCountMap[key] == null
              ? 1
              : _streamListenerCountMap[key]! + 1;
        },
      ).doOnCancel(() {
        if (_streamListenerCountMap[key] == null) {
          return;
        }

        _streamListenerCountMap[key] = _streamListenerCountMap[key]! - 1;

        if (_streamListenerCountMap[key] == 0) {
          _streamControllerMap[key]?.close();
          _streamControllerMap.remove(key);
          _streamListenerCountMap.remove(key);
        }
      });

  void add(
    int key,
    T value, {
    RefreshedType refreshing = RefreshedType.none,
  }) =>
      _streamControllerMap[key]?.add(
        StreamValue(
          value,
          refreshed: refreshing,
        ),
      );

  T? get(int key) => _streamControllerMap[key]?.value.value;

  bool containsKey(int key) => _streamControllerMap.containsKey(key);

  List<T> get values =>
      _streamControllerMap.values.map((e) => e.value.value).toList();

  List<BehaviorSubject<StreamValue<T>>> get subjects =>
      _streamControllerMap.values.toList();

  List<int> get keys => _streamControllerMap.keys.toList();
}
