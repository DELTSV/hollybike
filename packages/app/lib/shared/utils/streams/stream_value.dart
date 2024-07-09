class StreamValue<T, K> {
  final T value;
  final K? state;

  StreamValue(this.value, {this.state});
}