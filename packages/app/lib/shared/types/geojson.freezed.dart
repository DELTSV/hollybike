/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geojson.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GeoJSON _$GeoJSONFromJson(Map<String, dynamic> json) {
  return _GeoJSON.fromJson(json);
}

/// @nodoc
mixin _$GeoJSON {
  List<double> get bbox => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GeoJSONCopyWith<GeoJSON> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeoJSONCopyWith<$Res> {
  factory $GeoJSONCopyWith(GeoJSON value, $Res Function(GeoJSON) then) =
      _$GeoJSONCopyWithImpl<$Res, GeoJSON>;
  @useResult
  $Res call({List<double> bbox});
}

/// @nodoc
class _$GeoJSONCopyWithImpl<$Res, $Val extends GeoJSON>
    implements $GeoJSONCopyWith<$Res> {
  _$GeoJSONCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bbox = null,
  }) {
    return _then(_value.copyWith(
      bbox: null == bbox
          ? _value.bbox
          : bbox // ignore: cast_nullable_to_non_nullable
              as List<double>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GeoJSONImplCopyWith<$Res> implements $GeoJSONCopyWith<$Res> {
  factory _$$GeoJSONImplCopyWith(
          _$GeoJSONImpl value, $Res Function(_$GeoJSONImpl) then) =
      __$$GeoJSONImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<double> bbox});
}

/// @nodoc
class __$$GeoJSONImplCopyWithImpl<$Res>
    extends _$GeoJSONCopyWithImpl<$Res, _$GeoJSONImpl>
    implements _$$GeoJSONImplCopyWith<$Res> {
  __$$GeoJSONImplCopyWithImpl(
      _$GeoJSONImpl _value, $Res Function(_$GeoJSONImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bbox = null,
  }) {
    return _then(_$GeoJSONImpl(
      bbox: null == bbox
          ? _value._bbox
          : bbox // ignore: cast_nullable_to_non_nullable
              as List<double>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GeoJSONImpl extends _GeoJSON {
  const _$GeoJSONImpl({required final List<double> bbox})
      : _bbox = bbox,
        super._();

  factory _$GeoJSONImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeoJSONImplFromJson(json);

  final List<double> _bbox;
  @override
  List<double> get bbox {
    if (_bbox is EqualUnmodifiableListView) return _bbox;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bbox);
  }

  @override
  String toString() {
    return 'GeoJSON(bbox: $bbox)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeoJSONImpl &&
            const DeepCollectionEquality().equals(other._bbox, _bbox));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_bbox));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GeoJSONImplCopyWith<_$GeoJSONImpl> get copyWith =>
      __$$GeoJSONImplCopyWithImpl<_$GeoJSONImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GeoJSONImplToJson(
      this,
    );
  }
}

abstract class _GeoJSON extends GeoJSON {
  const factory _GeoJSON({required final List<double> bbox}) = _$GeoJSONImpl;
  const _GeoJSON._() : super._();

  factory _GeoJSON.fromJson(Map<String, dynamic> json) = _$GeoJSONImpl.fromJson;

  @override
  List<double> get bbox;
  @override
  @JsonKey(ignore: true)
  _$$GeoJSONImplCopyWith<_$GeoJSONImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
