// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_position_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ImagePositionMetadata _$ImagePositionMetadataFromJson(
    Map<String, dynamic> json) {
  return _ImagePositionMetadata.fromJson(json);
}

/// @nodoc
mixin _$ImagePositionMetadata {
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  int? get altitude => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ImagePositionMetadataCopyWith<ImagePositionMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImagePositionMetadataCopyWith<$Res> {
  factory $ImagePositionMetadataCopyWith(ImagePositionMetadata value,
          $Res Function(ImagePositionMetadata) then) =
      _$ImagePositionMetadataCopyWithImpl<$Res, ImagePositionMetadata>;
  @useResult
  $Res call({double latitude, double longitude, int? altitude});
}

/// @nodoc
class _$ImagePositionMetadataCopyWithImpl<$Res,
        $Val extends ImagePositionMetadata>
    implements $ImagePositionMetadataCopyWith<$Res> {
  _$ImagePositionMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? altitude = freezed,
  }) {
    return _then(_value.copyWith(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      altitude: freezed == altitude
          ? _value.altitude
          : altitude // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ImagePositionMetadataImplCopyWith<$Res>
    implements $ImagePositionMetadataCopyWith<$Res> {
  factory _$$ImagePositionMetadataImplCopyWith(
          _$ImagePositionMetadataImpl value,
          $Res Function(_$ImagePositionMetadataImpl) then) =
      __$$ImagePositionMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double latitude, double longitude, int? altitude});
}

/// @nodoc
class __$$ImagePositionMetadataImplCopyWithImpl<$Res>
    extends _$ImagePositionMetadataCopyWithImpl<$Res,
        _$ImagePositionMetadataImpl>
    implements _$$ImagePositionMetadataImplCopyWith<$Res> {
  __$$ImagePositionMetadataImplCopyWithImpl(_$ImagePositionMetadataImpl _value,
      $Res Function(_$ImagePositionMetadataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? altitude = freezed,
  }) {
    return _then(_$ImagePositionMetadataImpl(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      altitude: freezed == altitude
          ? _value.altitude
          : altitude // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ImagePositionMetadataImpl implements _ImagePositionMetadata {
  const _$ImagePositionMetadataImpl(
      {required this.latitude, required this.longitude, this.altitude});

  factory _$ImagePositionMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImagePositionMetadataImplFromJson(json);

  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final int? altitude;

  @override
  String toString() {
    return 'ImagePositionMetadata(latitude: $latitude, longitude: $longitude, altitude: $altitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImagePositionMetadataImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.altitude, altitude) ||
                other.altitude == altitude));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, latitude, longitude, altitude);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ImagePositionMetadataImplCopyWith<_$ImagePositionMetadataImpl>
      get copyWith => __$$ImagePositionMetadataImplCopyWithImpl<
          _$ImagePositionMetadataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ImagePositionMetadataImplToJson(
      this,
    );
  }
}

abstract class _ImagePositionMetadata implements ImagePositionMetadata {
  const factory _ImagePositionMetadata(
      {required final double latitude,
      required final double longitude,
      final int? altitude}) = _$ImagePositionMetadataImpl;

  factory _ImagePositionMetadata.fromJson(Map<String, dynamic> json) =
      _$ImagePositionMetadataImpl.fromJson;

  @override
  double get latitude;
  @override
  double get longitude;
  @override
  int? get altitude;
  @override
  @JsonKey(ignore: true)
  _$$ImagePositionMetadataImplCopyWith<_$ImagePositionMetadataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
