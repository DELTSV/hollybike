import 'dart:convert';

class PaginatedList<T> {
  final int page;
  final int totalPages;
  final int perPage;
  final int totalItems;

  final List<T> items;

  const PaginatedList({
    required this.page,
    required this.totalPages,
    required this.perPage,
    required this.totalItems,
    required this.items,
  });

  factory PaginatedList.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromItemJson,
  ) {
    return PaginatedList(
      items: (json["data"] as List)
          .map((item) => fromItemJson(item))
          .toList(),
      page: json["page"],
      totalPages: json["total_page"],
      perPage: json["per_page"],
      totalItems: json["total_data"],
    );
  }

  factory PaginatedList.fromResponseJson(
    String response, T Function(Map<String, dynamic>) fromItemJson,
  ) {
    final object = jsonDecode(response);
    verifyObjectAttributeNotNull(String attribute) {
      if (object[attribute] == null) {
        throw FormatException("Missing $attribute inside server response");
      }
    }

    [
      "page",
      "total_page",
      "per_page",
      "total_data",
      "data",
    ].forEach(verifyObjectAttributeNotNull);

    return PaginatedList.fromJson(object, fromItemJson);
  }
}
