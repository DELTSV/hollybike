// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaginatedList<T> _$PaginatedListFromJson<T>(
    Map<String, dynamic> json, T Function(Object?) fromJsonT) {
  return _PaginatedList<T>.fromJson(json, fromJsonT);
}

/// @nodoc
mixin _$PaginatedList<T> {
  int get page => throw _privateConstructorUsedError;
  @JsonKey(name: "total_page")
  int get totalPages => throw _privateConstructorUsedError;
  @JsonKey(name: "per_page")
  int get perPage => throw _privateConstructorUsedError;
  @JsonKey(name: "total_data")
  int get totalItems => throw _privateConstructorUsedError;
  @JsonKey(name: "data")
  List<T> get items => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaginatedListCopyWith<T, PaginatedList<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedListCopyWith<T, $Res> {
  factory $PaginatedListCopyWith(
          PaginatedList<T> value, $Res Function(PaginatedList<T>) then) =
      _$PaginatedListCopyWithImpl<T, $Res, PaginatedList<T>>;
  @useResult
  $Res call(
      {int page,
      @JsonKey(name: "total_page") int totalPages,
      @JsonKey(name: "per_page") int perPage,
      @JsonKey(name: "total_data") int totalItems,
      @JsonKey(name: "data") List<T> items});
}

/// @nodoc
class _$PaginatedListCopyWithImpl<T, $Res, $Val extends PaginatedList<T>>
    implements $PaginatedListCopyWith<T, $Res> {
  _$PaginatedListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? totalPages = null,
    Object? perPage = null,
    Object? totalItems = null,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginatedListImplCopyWith<T, $Res>
    implements $PaginatedListCopyWith<T, $Res> {
  factory _$$PaginatedListImplCopyWith(_$PaginatedListImpl<T> value,
          $Res Function(_$PaginatedListImpl<T>) then) =
      __$$PaginatedListImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {int page,
      @JsonKey(name: "total_page") int totalPages,
      @JsonKey(name: "per_page") int perPage,
      @JsonKey(name: "total_data") int totalItems,
      @JsonKey(name: "data") List<T> items});
}

/// @nodoc
class __$$PaginatedListImplCopyWithImpl<T, $Res>
    extends _$PaginatedListCopyWithImpl<T, $Res, _$PaginatedListImpl<T>>
    implements _$$PaginatedListImplCopyWith<T, $Res> {
  __$$PaginatedListImplCopyWithImpl(_$PaginatedListImpl<T> _value,
      $Res Function(_$PaginatedListImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? totalPages = null,
    Object? perPage = null,
    Object? totalItems = null,
    Object? items = null,
  }) {
    return _then(_$PaginatedListImpl<T>(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
    ));
  }
}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)
class _$PaginatedListImpl<T> extends _PaginatedList<T> {
  const _$PaginatedListImpl(
      {required this.page,
      @JsonKey(name: "total_page") required this.totalPages,
      @JsonKey(name: "per_page") required this.perPage,
      @JsonKey(name: "total_data") required this.totalItems,
      @JsonKey(name: "data") required final List<T> items})
      : _items = items,
        super._();

  factory _$PaginatedListImpl.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$$PaginatedListImplFromJson(json, fromJsonT);

  @override
  final int page;
  @override
  @JsonKey(name: "total_page")
  final int totalPages;
  @override
  @JsonKey(name: "per_page")
  final int perPage;
  @override
  @JsonKey(name: "total_data")
  final int totalItems;
  final List<T> _items;
  @override
  @JsonKey(name: "data")
  List<T> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'PaginatedList<$T>(page: $page, totalPages: $totalPages, perPage: $perPage, totalItems: $totalItems, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginatedListImpl<T> &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, page, totalPages, perPage,
      totalItems, const DeepCollectionEquality().hash(_items));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginatedListImplCopyWith<T, _$PaginatedListImpl<T>> get copyWith =>
      __$$PaginatedListImplCopyWithImpl<T, _$PaginatedListImpl<T>>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$$PaginatedListImplToJson<T>(this, toJsonT);
  }
}

abstract class _PaginatedList<T> extends PaginatedList<T> {
  const factory _PaginatedList(
          {required final int page,
          @JsonKey(name: "total_page") required final int totalPages,
          @JsonKey(name: "per_page") required final int perPage,
          @JsonKey(name: "total_data") required final int totalItems,
          @JsonKey(name: "data") required final List<T> items}) =
      _$PaginatedListImpl<T>;
  const _PaginatedList._() : super._();

  factory _PaginatedList.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =
      _$PaginatedListImpl<T>.fromJson;

  @override
  int get page;
  @override
  @JsonKey(name: "total_page")
  int get totalPages;
  @override
  @JsonKey(name: "per_page")
  int get perPage;
  @override
  @JsonKey(name: "total_data")
  int get totalItems;
  @override
  @JsonKey(name: "data")
  List<T> get items;
  @override
  @JsonKey(ignore: true)
  _$$PaginatedListImplCopyWith<T, _$PaginatedListImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
