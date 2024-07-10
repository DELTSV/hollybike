
import 'dart:developer';

import 'package:hollybike/shared/utils/streams/stream_value.dart';
import 'package:rxdart/rxdart.dart';

class StreamCounter<T, K> {
  final T seedValue;
  final K? initialState;
  final String name;

  BehaviorSubject<StreamValue<T, K>>? _streamController;
  int _listenerCount = 0;

  StreamCounter(this.seedValue, this.name, {this.initialState});

  Stream<StreamValue<T, K>> get stream {
    _streamController ??= BehaviorSubject<StreamValue<T, K>>.seeded(
      StreamValue(seedValue, state: initialState),
    );

    return _streamController!.stream.doOnListen(() {
      _listenerCount++;
      log(
        '$name is listening: $_listenerCount',
        name: 'StreamCounter',
      );
    }).doOnCancel(() {
      _listenerCount--;
      log(
        '$name is listening: $_listenerCount',
        name: 'StreamCounter',
      );
      if (_listenerCount == 0) {
        log(
          '$name is closing',
          name: 'StreamCounter',
        );
        _streamController?.close();
        _streamController = null;
      }
    });
  }

  void add(
      T value, {
        K? state,
      }) =>
      _streamController?.add(StreamValue(
        value,
        state: state ?? initialState,
      ));

  bool get isListening => _listenerCount > 0;

  T get value => _streamController?.value.value ?? seedValue;

  BehaviorSubject<StreamValue<T, K>>? get subject => _streamController;
}