List<T> addSeparators<T>(List<T> elements, T separator) {
  final listWithSeparators = elements.expand((element) => [element, separator]);
  return listWithSeparators.toList().sublist(0, listWithSeparators.length-1);
}
