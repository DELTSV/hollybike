import 'dart:convert';
import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated_list.g.dart';

part 'paginated_list.freezed.dart';

@Freezed(genericArgumentFactories: true)
class PaginatedList<T> with _$PaginatedList<T> {
  const factory PaginatedList({
    required int page,
    @JsonKey(name: "total_page") required int totalPages,
    @JsonKey(name: "per_page") required int perPage,
    @JsonKey(name: "total_data") required int totalItems,
    @JsonKey(name: "data") required List<T> items,
  }) = _PaginatedList;

  factory PaginatedList.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJson,
  ) =>
      _$PaginatedListFromJson(json, fromJson);

  factory PaginatedList.fromResponseJson(
    Uint8List response,
    T Function(Map<String, dynamic> json) fromItemJson,
  ) {
    return PaginatedList.fromJson(
      jsonDecode(utf8.decode(response)),
      (Object? test) => fromItemJson(test as Map<String, dynamic>),
    );
  }
}
