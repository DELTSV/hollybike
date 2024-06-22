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
