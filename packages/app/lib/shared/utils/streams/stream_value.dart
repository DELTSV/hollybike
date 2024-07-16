/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
class StreamValue<T, K> {
  final T value;
  final K? state;

  StreamValue(this.value, {this.state});
}