/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
void verifyObjectAttributesNotNull(
  Map<String, dynamic> object,
  List<String> requiredAttributes,
) {
  verifyAttribute(String attribute) {
    if (object[attribute] == null) {
      throw FormatException("Missing $attribute inside provided object");
    }
  }

  requiredAttributes.forEach(verifyAttribute);
}
