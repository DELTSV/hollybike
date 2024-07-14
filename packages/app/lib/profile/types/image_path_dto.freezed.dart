// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_path_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ImagePathDto _$ImagePathDtoFromJson(Map<String, dynamic> json) {
  return _ImagePathDto.fromJson(json);
}

/// @nodoc
mixin _$ImagePathDto {
  String get path => throw _privateConstructorUsedError;
  String get key => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ImagePathDtoCopyWith<ImagePathDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImagePathDtoCopyWith<$Res> {
  factory $ImagePathDtoCopyWith(
          ImagePathDto value, $Res Function(ImagePathDto) then) =
      _$ImagePathDtoCopyWithImpl<$Res, ImagePathDto>;
  @useResult
  $Res call({String path, String key});
}

/// @nodoc
class _$ImagePathDtoCopyWithImpl<$Res, $Val extends ImagePathDto>
    implements $ImagePathDtoCopyWith<$Res> {
  _$ImagePathDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? key = null,
  }) {
    return _then(_value.copyWith(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ImagePathDtoImplCopyWith<$Res>
    implements $ImagePathDtoCopyWith<$Res> {
  factory _$$ImagePathDtoImplCopyWith(
          _$ImagePathDtoImpl value, $Res Function(_$ImagePathDtoImpl) then) =
      __$$ImagePathDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String path, String key});
}

/// @nodoc
class __$$ImagePathDtoImplCopyWithImpl<$Res>
    extends _$ImagePathDtoCopyWithImpl<$Res, _$ImagePathDtoImpl>
    implements _$$ImagePathDtoImplCopyWith<$Res> {
  __$$ImagePathDtoImplCopyWithImpl(
      _$ImagePathDtoImpl _value, $Res Function(_$ImagePathDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? key = null,
  }) {
    return _then(_$ImagePathDtoImpl(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ImagePathDtoImpl implements _ImagePathDto {
  const _$ImagePathDtoImpl({required this.path, required this.key});

  factory _$ImagePathDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImagePathDtoImplFromJson(json);

  @override
  final String path;
  @override
  final String key;

  @override
  String toString() {
    return 'ImagePathDto(path: $path, key: $key)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImagePathDtoImpl &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.key, key) || other.key == key));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, path, key);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ImagePathDtoImplCopyWith<_$ImagePathDtoImpl> get copyWith =>
      __$$ImagePathDtoImplCopyWithImpl<_$ImagePathDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ImagePathDtoImplToJson(
      this,
    );
  }
}

abstract class _ImagePathDto implements ImagePathDto {
  const factory _ImagePathDto(
      {required final String path,
      required final String key}) = _$ImagePathDtoImpl;

  factory _ImagePathDto.fromJson(Map<String, dynamic> json) =
      _$ImagePathDtoImpl.fromJson;

  @override
  String get path;
  @override
  String get key;
  @override
  @JsonKey(ignore: true)
  _$$ImagePathDtoImplCopyWith<_$ImagePathDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
