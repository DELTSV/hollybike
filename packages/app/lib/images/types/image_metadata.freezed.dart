// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ImageMetadata _$ImageMetadataFromJson(Map<String, dynamic> json) {
  return _ImageMetadata.fromJson(json);
}

/// @nodoc
mixin _$ImageMetadata {
  @JsonKey(toJson: dateToJson, name: "taken_date_time")
  DateTime? get takenDateTime => throw _privateConstructorUsedError;
  @JsonKey(name: "position")
  ImagePositionMetadata? get position => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ImageMetadataCopyWith<ImageMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageMetadataCopyWith<$Res> {
  factory $ImageMetadataCopyWith(
          ImageMetadata value, $Res Function(ImageMetadata) then) =
      _$ImageMetadataCopyWithImpl<$Res, ImageMetadata>;
  @useResult
  $Res call(
      {@JsonKey(toJson: dateToJson, name: "taken_date_time")
      DateTime? takenDateTime,
      @JsonKey(name: "position") ImagePositionMetadata? position});

  $ImagePositionMetadataCopyWith<$Res>? get position;
}

/// @nodoc
class _$ImageMetadataCopyWithImpl<$Res, $Val extends ImageMetadata>
    implements $ImageMetadataCopyWith<$Res> {
  _$ImageMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? takenDateTime = freezed,
    Object? position = freezed,
  }) {
    return _then(_value.copyWith(
      takenDateTime: freezed == takenDateTime
          ? _value.takenDateTime
          : takenDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as ImagePositionMetadata?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ImagePositionMetadataCopyWith<$Res>? get position {
    if (_value.position == null) {
      return null;
    }

    return $ImagePositionMetadataCopyWith<$Res>(_value.position!, (value) {
      return _then(_value.copyWith(position: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ImageMetadataImplCopyWith<$Res>
    implements $ImageMetadataCopyWith<$Res> {
  factory _$$ImageMetadataImplCopyWith(
          _$ImageMetadataImpl value, $Res Function(_$ImageMetadataImpl) then) =
      __$$ImageMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(toJson: dateToJson, name: "taken_date_time")
      DateTime? takenDateTime,
      @JsonKey(name: "position") ImagePositionMetadata? position});

  @override
  $ImagePositionMetadataCopyWith<$Res>? get position;
}

/// @nodoc
class __$$ImageMetadataImplCopyWithImpl<$Res>
    extends _$ImageMetadataCopyWithImpl<$Res, _$ImageMetadataImpl>
    implements _$$ImageMetadataImplCopyWith<$Res> {
  __$$ImageMetadataImplCopyWithImpl(
      _$ImageMetadataImpl _value, $Res Function(_$ImageMetadataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? takenDateTime = freezed,
    Object? position = freezed,
  }) {
    return _then(_$ImageMetadataImpl(
      takenDateTime: freezed == takenDateTime
          ? _value.takenDateTime
          : takenDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as ImagePositionMetadata?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ImageMetadataImpl implements _ImageMetadata {
  const _$ImageMetadataImpl(
      {@JsonKey(toJson: dateToJson, name: "taken_date_time") this.takenDateTime,
      @JsonKey(name: "position") this.position});

  factory _$ImageMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImageMetadataImplFromJson(json);

  @override
  @JsonKey(toJson: dateToJson, name: "taken_date_time")
  final DateTime? takenDateTime;
  @override
  @JsonKey(name: "position")
  final ImagePositionMetadata? position;

  @override
  String toString() {
    return 'ImageMetadata(takenDateTime: $takenDateTime, position: $position)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageMetadataImpl &&
            (identical(other.takenDateTime, takenDateTime) ||
                other.takenDateTime == takenDateTime) &&
            (identical(other.position, position) ||
                other.position == position));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, takenDateTime, position);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ImageMetadataImplCopyWith<_$ImageMetadataImpl> get copyWith =>
      __$$ImageMetadataImplCopyWithImpl<_$ImageMetadataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ImageMetadataImplToJson(
      this,
    );
  }
}

abstract class _ImageMetadata implements ImageMetadata {
  const factory _ImageMetadata(
          {@JsonKey(toJson: dateToJson, name: "taken_date_time")
          final DateTime? takenDateTime,
          @JsonKey(name: "position") final ImagePositionMetadata? position}) =
      _$ImageMetadataImpl;

  factory _ImageMetadata.fromJson(Map<String, dynamic> json) =
      _$ImageMetadataImpl.fromJson;

  @override
  @JsonKey(toJson: dateToJson, name: "taken_date_time")
  DateTime? get takenDateTime;
  @override
  @JsonKey(name: "position")
  ImagePositionMetadata? get position;
  @override
  @JsonKey(ignore: true)
  _$$ImageMetadataImplCopyWith<_$ImageMetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
