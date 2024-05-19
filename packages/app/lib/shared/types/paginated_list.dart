import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'paginated_list.g.dart';

@immutable
@JsonSerializable(genericArgumentFactories: true)
class PaginatedList<T> {
  final int page;

  @JsonKey(name: "total_page")
  final int totalPages;

  @JsonKey(name: "per_page")
  final int perPage;

  @JsonKey(name: "total_data")
  final int totalItems;

  @JsonKey(name: "data")
  final List<T> items;

  const PaginatedList({
    required this.page,
    required this.totalPages,
    required this.perPage,
    required this.totalItems,
    required this.items,
  });

  factory PaginatedList.fromResponseJson(
    Uint8List response,
    T Function(Object? json) fromItemJson,
  ) {
    final object = jsonDecode(utf8.decode(response));
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

  factory PaginatedList.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromItemJson,
  ) =>
      _$PaginatedListFromJson(json, fromItemJson);

  Map<String, dynamic> toJson(
    Object? Function(T value) toJson,
  ) =>
      _$PaginatedListToJson(this, toJson);
}
