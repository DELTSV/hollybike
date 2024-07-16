/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
List<T> addSeparators<T>(List<T> elements, T separator) {
  if (elements.isEmpty) return [];

  final listWithSeparators = elements.expand((element) => [element, separator]);
  return listWithSeparators.toList().sublist(0, listWithSeparators.length - 1);
}
