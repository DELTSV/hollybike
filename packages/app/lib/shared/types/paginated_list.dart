/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/shared/types/json_map.dart';

part 'paginated_list.freezed.dart';
part 'paginated_list.g.dart';

enum RefreshedType {
  none,
  refreshed,
  refreshedAndHasMore,
}

@Freezed(genericArgumentFactories: true)
class PaginatedList<T> with _$PaginatedList<T> {
  const PaginatedList._();

  const factory PaginatedList({
    required int page,
    @JsonKey(name: "total_page") required int totalPages,
    @JsonKey(name: "per_page") required int perPage,
    @JsonKey(name: "total_data") required int totalItems,
    @JsonKey(name: "data") required List<T> items,
  }) = _PaginatedList;

  RefreshedType get refreshedType {
    return page < totalPages - 1
        ? RefreshedType.refreshedAndHasMore
        : RefreshedType.refreshed;
  }

  factory PaginatedList.fromJson(
    JsonMap json,
    T Function(JsonMap json) fromItemJson,
  ) =>
      _$PaginatedListFromJson(
        json,
        (Object? test) => fromItemJson(test as JsonMap),
      );
}
