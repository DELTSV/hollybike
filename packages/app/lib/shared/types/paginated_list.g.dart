// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedList<T> _$PaginatedListFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    PaginatedList<T>(
      page: (json['page'] as num).toInt(),
      totalPages: (json['total_page'] as num).toInt(),
      perPage: (json['per_page'] as num).toInt(),
      totalItems: (json['total_data'] as num).toInt(),
      items: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
    );

Map<String, dynamic> _$PaginatedListToJson<T>(
  PaginatedList<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'page': instance.page,
      'total_page': instance.totalPages,
      'per_page': instance.perPage,
      'total_data': instance.totalItems,
      'data': instance.items.map(toJsonT).toList(),
    };
