class Association {
  final int id;
  final String name;
  final String status;

  const Association({
    required this.id,
    required this.name,
    required this.status,
  });

  static Association fromJsonObject(dynamic object) {
    verifyObjectAttributeNotNull(String attribute) {
      if (object[attribute] == null) {
        throw FormatException("Missing $attribute inside server response");
      }
    }

    [
      "id",
      "name",
      "status",
    ].forEach(verifyObjectAttributeNotNull);

    return Association(
      id: object["id"],
      name: object["name"],
      status: object["status"],
    );
  }
}
