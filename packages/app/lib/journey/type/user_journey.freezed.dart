// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_journey.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserJourney _$UserJourneyFromJson(Map<String, dynamic> json) {
  return _UserJourney.fromJson(json);
}

/// @nodoc
mixin _$UserJourney {
  int get id => throw _privateConstructorUsedError;
  String get file => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_speed')
  double? get avgSpeed => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_distance')
  int? get totalDistance => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_elevation')
  double? get minElevation => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_elevation')
  double? get maxElevation => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_elevation_gain')
  double? get totalElevationGain => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_elevation_loss')
  double? get totalElevationLoss => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_time')
  int? get totalTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_speed')
  double? get maxSpeed => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_g_force')
  double? get avgGForce => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_g_force')
  double? get maxGForce => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserJourneyCopyWith<UserJourney> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserJourneyCopyWith<$Res> {
  factory $UserJourneyCopyWith(
          UserJourney value, $Res Function(UserJourney) then) =
      _$UserJourneyCopyWithImpl<$Res, UserJourney>;
  @useResult
  $Res call(
      {int id,
      String file,
      @JsonKey(name: 'avg_speed') double? avgSpeed,
      @JsonKey(name: 'total_distance') int? totalDistance,
      @JsonKey(name: 'min_elevation') double? minElevation,
      @JsonKey(name: 'max_elevation') double? maxElevation,
      @JsonKey(name: 'total_elevation_gain') double? totalElevationGain,
      @JsonKey(name: 'total_elevation_loss') double? totalElevationLoss,
      @JsonKey(name: 'total_time') int? totalTime,
      @JsonKey(name: 'max_speed') double? maxSpeed,
      @JsonKey(name: 'avg_g_force') double? avgGForce,
      @JsonKey(name: 'max_g_force') double? maxGForce,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class _$UserJourneyCopyWithImpl<$Res, $Val extends UserJourney>
    implements $UserJourneyCopyWith<$Res> {
  _$UserJourneyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? file = null,
    Object? avgSpeed = freezed,
    Object? totalDistance = freezed,
    Object? minElevation = freezed,
    Object? maxElevation = freezed,
    Object? totalElevationGain = freezed,
    Object? totalElevationLoss = freezed,
    Object? totalTime = freezed,
    Object? maxSpeed = freezed,
    Object? avgGForce = freezed,
    Object? maxGForce = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      file: null == file
          ? _value.file
          : file // ignore: cast_nullable_to_non_nullable
              as String,
      avgSpeed: freezed == avgSpeed
          ? _value.avgSpeed
          : avgSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
      totalDistance: freezed == totalDistance
          ? _value.totalDistance
          : totalDistance // ignore: cast_nullable_to_non_nullable
              as int?,
      minElevation: freezed == minElevation
          ? _value.minElevation
          : minElevation // ignore: cast_nullable_to_non_nullable
              as double?,
      maxElevation: freezed == maxElevation
          ? _value.maxElevation
          : maxElevation // ignore: cast_nullable_to_non_nullable
              as double?,
      totalElevationGain: freezed == totalElevationGain
          ? _value.totalElevationGain
          : totalElevationGain // ignore: cast_nullable_to_non_nullable
              as double?,
      totalElevationLoss: freezed == totalElevationLoss
          ? _value.totalElevationLoss
          : totalElevationLoss // ignore: cast_nullable_to_non_nullable
              as double?,
      totalTime: freezed == totalTime
          ? _value.totalTime
          : totalTime // ignore: cast_nullable_to_non_nullable
              as int?,
      maxSpeed: freezed == maxSpeed
          ? _value.maxSpeed
          : maxSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
      avgGForce: freezed == avgGForce
          ? _value.avgGForce
          : avgGForce // ignore: cast_nullable_to_non_nullable
              as double?,
      maxGForce: freezed == maxGForce
          ? _value.maxGForce
          : maxGForce // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserJourneyImplCopyWith<$Res>
    implements $UserJourneyCopyWith<$Res> {
  factory _$$UserJourneyImplCopyWith(
          _$UserJourneyImpl value, $Res Function(_$UserJourneyImpl) then) =
      __$$UserJourneyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String file,
      @JsonKey(name: 'avg_speed') double? avgSpeed,
      @JsonKey(name: 'total_distance') int? totalDistance,
      @JsonKey(name: 'min_elevation') double? minElevation,
      @JsonKey(name: 'max_elevation') double? maxElevation,
      @JsonKey(name: 'total_elevation_gain') double? totalElevationGain,
      @JsonKey(name: 'total_elevation_loss') double? totalElevationLoss,
      @JsonKey(name: 'total_time') int? totalTime,
      @JsonKey(name: 'max_speed') double? maxSpeed,
      @JsonKey(name: 'avg_g_force') double? avgGForce,
      @JsonKey(name: 'max_g_force') double? maxGForce,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class __$$UserJourneyImplCopyWithImpl<$Res>
    extends _$UserJourneyCopyWithImpl<$Res, _$UserJourneyImpl>
    implements _$$UserJourneyImplCopyWith<$Res> {
  __$$UserJourneyImplCopyWithImpl(
      _$UserJourneyImpl _value, $Res Function(_$UserJourneyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? file = null,
    Object? avgSpeed = freezed,
    Object? totalDistance = freezed,
    Object? minElevation = freezed,
    Object? maxElevation = freezed,
    Object? totalElevationGain = freezed,
    Object? totalElevationLoss = freezed,
    Object? totalTime = freezed,
    Object? maxSpeed = freezed,
    Object? avgGForce = freezed,
    Object? maxGForce = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$UserJourneyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      file: null == file
          ? _value.file
          : file // ignore: cast_nullable_to_non_nullable
              as String,
      avgSpeed: freezed == avgSpeed
          ? _value.avgSpeed
          : avgSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
      totalDistance: freezed == totalDistance
          ? _value.totalDistance
          : totalDistance // ignore: cast_nullable_to_non_nullable
              as int?,
      minElevation: freezed == minElevation
          ? _value.minElevation
          : minElevation // ignore: cast_nullable_to_non_nullable
              as double?,
      maxElevation: freezed == maxElevation
          ? _value.maxElevation
          : maxElevation // ignore: cast_nullable_to_non_nullable
              as double?,
      totalElevationGain: freezed == totalElevationGain
          ? _value.totalElevationGain
          : totalElevationGain // ignore: cast_nullable_to_non_nullable
              as double?,
      totalElevationLoss: freezed == totalElevationLoss
          ? _value.totalElevationLoss
          : totalElevationLoss // ignore: cast_nullable_to_non_nullable
              as double?,
      totalTime: freezed == totalTime
          ? _value.totalTime
          : totalTime // ignore: cast_nullable_to_non_nullable
              as int?,
      maxSpeed: freezed == maxSpeed
          ? _value.maxSpeed
          : maxSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
      avgGForce: freezed == avgGForce
          ? _value.avgGForce
          : avgGForce // ignore: cast_nullable_to_non_nullable
              as double?,
      maxGForce: freezed == maxGForce
          ? _value.maxGForce
          : maxGForce // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserJourneyImpl extends _UserJourney {
  const _$UserJourneyImpl(
      {required this.id,
      required this.file,
      @JsonKey(name: 'avg_speed') required this.avgSpeed,
      @JsonKey(name: 'total_distance') required this.totalDistance,
      @JsonKey(name: 'min_elevation') required this.minElevation,
      @JsonKey(name: 'max_elevation') required this.maxElevation,
      @JsonKey(name: 'total_elevation_gain') required this.totalElevationGain,
      @JsonKey(name: 'total_elevation_loss') required this.totalElevationLoss,
      @JsonKey(name: 'total_time') required this.totalTime,
      @JsonKey(name: 'max_speed') required this.maxSpeed,
      @JsonKey(name: 'avg_g_force') required this.avgGForce,
      @JsonKey(name: 'max_g_force') required this.maxGForce,
      @JsonKey(name: 'created_at') required this.createdAt})
      : super._();

  factory _$UserJourneyImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserJourneyImplFromJson(json);

  @override
  final int id;
  @override
  final String file;
  @override
  @JsonKey(name: 'avg_speed')
  final double? avgSpeed;
  @override
  @JsonKey(name: 'total_distance')
  final int? totalDistance;
  @override
  @JsonKey(name: 'min_elevation')
  final double? minElevation;
  @override
  @JsonKey(name: 'max_elevation')
  final double? maxElevation;
  @override
  @JsonKey(name: 'total_elevation_gain')
  final double? totalElevationGain;
  @override
  @JsonKey(name: 'total_elevation_loss')
  final double? totalElevationLoss;
  @override
  @JsonKey(name: 'total_time')
  final int? totalTime;
  @override
  @JsonKey(name: 'max_speed')
  final double? maxSpeed;
  @override
  @JsonKey(name: 'avg_g_force')
  final double? avgGForce;
  @override
  @JsonKey(name: 'max_g_force')
  final double? maxGForce;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'UserJourney(id: $id, file: $file, avgSpeed: $avgSpeed, totalDistance: $totalDistance, minElevation: $minElevation, maxElevation: $maxElevation, totalElevationGain: $totalElevationGain, totalElevationLoss: $totalElevationLoss, totalTime: $totalTime, maxSpeed: $maxSpeed, avgGForce: $avgGForce, maxGForce: $maxGForce, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserJourneyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.file, file) || other.file == file) &&
            (identical(other.avgSpeed, avgSpeed) ||
                other.avgSpeed == avgSpeed) &&
            (identical(other.totalDistance, totalDistance) ||
                other.totalDistance == totalDistance) &&
            (identical(other.minElevation, minElevation) ||
                other.minElevation == minElevation) &&
            (identical(other.maxElevation, maxElevation) ||
                other.maxElevation == maxElevation) &&
            (identical(other.totalElevationGain, totalElevationGain) ||
                other.totalElevationGain == totalElevationGain) &&
            (identical(other.totalElevationLoss, totalElevationLoss) ||
                other.totalElevationLoss == totalElevationLoss) &&
            (identical(other.totalTime, totalTime) ||
                other.totalTime == totalTime) &&
            (identical(other.maxSpeed, maxSpeed) ||
                other.maxSpeed == maxSpeed) &&
            (identical(other.avgGForce, avgGForce) ||
                other.avgGForce == avgGForce) &&
            (identical(other.maxGForce, maxGForce) ||
                other.maxGForce == maxGForce) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      file,
      avgSpeed,
      totalDistance,
      minElevation,
      maxElevation,
      totalElevationGain,
      totalElevationLoss,
      totalTime,
      maxSpeed,
      avgGForce,
      maxGForce,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserJourneyImplCopyWith<_$UserJourneyImpl> get copyWith =>
      __$$UserJourneyImplCopyWithImpl<_$UserJourneyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserJourneyImplToJson(
      this,
    );
  }
}

abstract class _UserJourney extends UserJourney {
  const factory _UserJourney(
          {required final int id,
          required final String file,
          @JsonKey(name: 'avg_speed') required final double? avgSpeed,
          @JsonKey(name: 'total_distance') required final int? totalDistance,
          @JsonKey(name: 'min_elevation') required final double? minElevation,
          @JsonKey(name: 'max_elevation') required final double? maxElevation,
          @JsonKey(name: 'total_elevation_gain')
          required final double? totalElevationGain,
          @JsonKey(name: 'total_elevation_loss')
          required final double? totalElevationLoss,
          @JsonKey(name: 'total_time') required final int? totalTime,
          @JsonKey(name: 'max_speed') required final double? maxSpeed,
          @JsonKey(name: 'avg_g_force') required final double? avgGForce,
          @JsonKey(name: 'max_g_force') required final double? maxGForce,
          @JsonKey(name: 'created_at') required final DateTime createdAt}) =
      _$UserJourneyImpl;
  const _UserJourney._() : super._();

  factory _UserJourney.fromJson(Map<String, dynamic> json) =
      _$UserJourneyImpl.fromJson;

  @override
  int get id;
  @override
  String get file;
  @override
  @JsonKey(name: 'avg_speed')
  double? get avgSpeed;
  @override
  @JsonKey(name: 'total_distance')
  int? get totalDistance;
  @override
  @JsonKey(name: 'min_elevation')
  double? get minElevation;
  @override
  @JsonKey(name: 'max_elevation')
  double? get maxElevation;
  @override
  @JsonKey(name: 'total_elevation_gain')
  double? get totalElevationGain;
  @override
  @JsonKey(name: 'total_elevation_loss')
  double? get totalElevationLoss;
  @override
  @JsonKey(name: 'total_time')
  int? get totalTime;
  @override
  @JsonKey(name: 'max_speed')
  double? get maxSpeed;
  @override
  @JsonKey(name: 'avg_g_force')
  double? get avgGForce;
  @override
  @JsonKey(name: 'max_g_force')
  double? get maxGForce;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$UserJourneyImplCopyWith<_$UserJourneyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
