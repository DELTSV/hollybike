import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/shared/types/json_map.dart';

part 'paginated_list.freezed.dart';
part 'paginated_list.g.dart';

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
    JsonMap json,
    T Function(JsonMap json) fromItemJson,
  ) =>
      _$PaginatedListFromJson(
        json,
        (Object? test) => fromItemJson(test as JsonMap),
      );
}
