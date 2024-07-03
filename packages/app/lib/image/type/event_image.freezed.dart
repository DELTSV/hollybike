// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventImage _$EventImageFromJson(Map<String, dynamic> json) {
  return _EventImage.fromJson(json);
}

/// @nodoc
mixin _$EventImage {
  int get id => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  int get width => throw _privateConstructorUsedError;
  int get height => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventImageCopyWith<EventImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventImageCopyWith<$Res> {
  factory $EventImageCopyWith(
          EventImage value, $Res Function(EventImage) then) =
      _$EventImageCopyWithImpl<$Res, EventImage>;
  @useResult
  $Res call({int id, String url, int size, int width, int height});
}

/// @nodoc
class _$EventImageCopyWithImpl<$Res, $Val extends EventImage>
    implements $EventImageCopyWith<$Res> {
  _$EventImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? size = null,
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventImageImplCopyWith<$Res>
    implements $EventImageCopyWith<$Res> {
  factory _$$EventImageImplCopyWith(
          _$EventImageImpl value, $Res Function(_$EventImageImpl) then) =
      __$$EventImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String url, int size, int width, int height});
}

/// @nodoc
class __$$EventImageImplCopyWithImpl<$Res>
    extends _$EventImageCopyWithImpl<$Res, _$EventImageImpl>
    implements _$$EventImageImplCopyWith<$Res> {
  __$$EventImageImplCopyWithImpl(
      _$EventImageImpl _value, $Res Function(_$EventImageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? size = null,
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_$EventImageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventImageImpl implements _EventImage {
  const _$EventImageImpl(
      {required this.id,
      required this.url,
      required this.size,
      required this.width,
      required this.height});

  factory _$EventImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventImageImplFromJson(json);

  @override
  final int id;
  @override
  final String url;
  @override
  final int size;
  @override
  final int width;
  @override
  final int height;

  @override
  String toString() {
    return 'EventImage(id: $id, url: $url, size: $size, width: $width, height: $height)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventImageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, url, size, width, height);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventImageImplCopyWith<_$EventImageImpl> get copyWith =>
      __$$EventImageImplCopyWithImpl<_$EventImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventImageImplToJson(
      this,
    );
  }
}

abstract class _EventImage implements EventImage {
  const factory _EventImage(
      {required final int id,
      required final String url,
      required final int size,
      required final int width,
      required final int height}) = _$EventImageImpl;

  factory _EventImage.fromJson(Map<String, dynamic> json) =
      _$EventImageImpl.fromJson;

  @override
  int get id;
  @override
  String get url;
  @override
  int get size;
  @override
  int get width;
  @override
  int get height;
  @override
  @JsonKey(ignore: true)
  _$$EventImageImplCopyWith<_$EventImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
