import 'package:hollybike/shared/utils/streams/stream_counter.dart';
import 'package:hollybike/shared/utils/streams/stream_value.dart';
import 'package:rxdart/rxdart.dart';

class StreamMapper<T, K> {
  final _streamCounterMap = <int, StreamCounter<T, K>>{};

  final String? name;
  final T seedValue;
  final K? initialState;

  StreamMapper(
      {required this.seedValue, this.initialState, this.name = 'StreamMapper'});

  Stream<StreamValue<T, K>> stream(int key) {
    if (!_streamCounterMap.containsKey(key)) {
      _streamCounterMap[key] = StreamCounter<T, K>(
        seedValue,
        '$name-$key',
        initialState: initialState,
      );
    }

    return _streamCounterMap[key]!.stream.doOnCancel(() {
      if (!_streamCounterMap[key]!.isListening) {
        _streamCounterMap.remove(key);
      }
    });
  }

  void add(
    int key,
    T value, {
    K? state,
  }) {
    _streamCounterMap[key]?.add(
      value,
      state: state,
    );
  }

  T? get(int key) => _streamCounterMap[key]?.value;

  bool containsKey(int key) => _streamCounterMap.containsKey(key);

  List<T> get values => _streamCounterMap.values.map((e) => e.value).toList();

  List<StreamCounter<T, K>> get counters => _streamCounterMap.values.toList();

  List<int> get keys => _streamCounterMap.keys.toList();
}
