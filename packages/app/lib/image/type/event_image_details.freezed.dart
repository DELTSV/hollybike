/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_image_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventImageDetails _$EventImageDetailsFromJson(Map<String, dynamic> json) {
  return _EventImageDetails.fromJson(json);
}

/// @nodoc
mixin _$EventImageDetails {
  bool get isOwner => throw _privateConstructorUsedError;
  MinimalUser get owner => throw _privateConstructorUsedError;
  MinimalEvent get event => throw _privateConstructorUsedError;
  Position? get position => throw _privateConstructorUsedError;
  @JsonKey(name: "taken_date_time")
  DateTime? get takenDateTime => throw _privateConstructorUsedError;
  @JsonKey(name: "uploaded_date_time")
  DateTime get uploadDateTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventImageDetailsCopyWith<EventImageDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventImageDetailsCopyWith<$Res> {
  factory $EventImageDetailsCopyWith(
          EventImageDetails value, $Res Function(EventImageDetails) then) =
      _$EventImageDetailsCopyWithImpl<$Res, EventImageDetails>;
  @useResult
  $Res call(
      {bool isOwner,
      MinimalUser owner,
      MinimalEvent event,
      Position? position,
      @JsonKey(name: "taken_date_time") DateTime? takenDateTime,
      @JsonKey(name: "uploaded_date_time") DateTime uploadDateTime});

  $MinimalUserCopyWith<$Res> get owner;
  $MinimalEventCopyWith<$Res> get event;
  $PositionCopyWith<$Res>? get position;
}

/// @nodoc
class _$EventImageDetailsCopyWithImpl<$Res, $Val extends EventImageDetails>
    implements $EventImageDetailsCopyWith<$Res> {
  _$EventImageDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOwner = null,
    Object? owner = null,
    Object? event = null,
    Object? position = freezed,
    Object? takenDateTime = freezed,
    Object? uploadDateTime = null,
  }) {
    return _then(_value.copyWith(
      isOwner: null == isOwner
          ? _value.isOwner
          : isOwner // ignore: cast_nullable_to_non_nullable
              as bool,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as MinimalUser,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as MinimalEvent,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Position?,
      takenDateTime: freezed == takenDateTime
          ? _value.takenDateTime
          : takenDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      uploadDateTime: null == uploadDateTime
          ? _value.uploadDateTime
          : uploadDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MinimalUserCopyWith<$Res> get owner {
    return $MinimalUserCopyWith<$Res>(_value.owner, (value) {
      return _then(_value.copyWith(owner: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $MinimalEventCopyWith<$Res> get event {
    return $MinimalEventCopyWith<$Res>(_value.event, (value) {
      return _then(_value.copyWith(event: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PositionCopyWith<$Res>? get position {
    if (_value.position == null) {
      return null;
    }

    return $PositionCopyWith<$Res>(_value.position!, (value) {
      return _then(_value.copyWith(position: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EventImageDetailsImplCopyWith<$Res>
    implements $EventImageDetailsCopyWith<$Res> {
  factory _$$EventImageDetailsImplCopyWith(_$EventImageDetailsImpl value,
          $Res Function(_$EventImageDetailsImpl) then) =
      __$$EventImageDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isOwner,
      MinimalUser owner,
      MinimalEvent event,
      Position? position,
      @JsonKey(name: "taken_date_time") DateTime? takenDateTime,
      @JsonKey(name: "uploaded_date_time") DateTime uploadDateTime});

  @override
  $MinimalUserCopyWith<$Res> get owner;
  @override
  $MinimalEventCopyWith<$Res> get event;
  @override
  $PositionCopyWith<$Res>? get position;
}

/// @nodoc
class __$$EventImageDetailsImplCopyWithImpl<$Res>
    extends _$EventImageDetailsCopyWithImpl<$Res, _$EventImageDetailsImpl>
    implements _$$EventImageDetailsImplCopyWith<$Res> {
  __$$EventImageDetailsImplCopyWithImpl(_$EventImageDetailsImpl _value,
      $Res Function(_$EventImageDetailsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOwner = null,
    Object? owner = null,
    Object? event = null,
    Object? position = freezed,
    Object? takenDateTime = freezed,
    Object? uploadDateTime = null,
  }) {
    return _then(_$EventImageDetailsImpl(
      isOwner: null == isOwner
          ? _value.isOwner
          : isOwner // ignore: cast_nullable_to_non_nullable
              as bool,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as MinimalUser,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as MinimalEvent,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Position?,
      takenDateTime: freezed == takenDateTime
          ? _value.takenDateTime
          : takenDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      uploadDateTime: null == uploadDateTime
          ? _value.uploadDateTime
          : uploadDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventImageDetailsImpl implements _EventImageDetails {
  const _$EventImageDetailsImpl(
      {required this.isOwner,
      required this.owner,
      required this.event,
      this.position,
      @JsonKey(name: "taken_date_time") required this.takenDateTime,
      @JsonKey(name: "uploaded_date_time") required this.uploadDateTime});

  factory _$EventImageDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventImageDetailsImplFromJson(json);

  @override
  final bool isOwner;
  @override
  final MinimalUser owner;
  @override
  final MinimalEvent event;
  @override
  final Position? position;
  @override
  @JsonKey(name: "taken_date_time")
  final DateTime? takenDateTime;
  @override
  @JsonKey(name: "uploaded_date_time")
  final DateTime uploadDateTime;

  @override
  String toString() {
    return 'EventImageDetails(isOwner: $isOwner, owner: $owner, event: $event, position: $position, takenDateTime: $takenDateTime, uploadDateTime: $uploadDateTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventImageDetailsImpl &&
            (identical(other.isOwner, isOwner) || other.isOwner == isOwner) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.takenDateTime, takenDateTime) ||
                other.takenDateTime == takenDateTime) &&
            (identical(other.uploadDateTime, uploadDateTime) ||
                other.uploadDateTime == uploadDateTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, isOwner, owner, event, position,
      takenDateTime, uploadDateTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventImageDetailsImplCopyWith<_$EventImageDetailsImpl> get copyWith =>
      __$$EventImageDetailsImplCopyWithImpl<_$EventImageDetailsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventImageDetailsImplToJson(
      this,
    );
  }
}

abstract class _EventImageDetails implements EventImageDetails {
  const factory _EventImageDetails(
      {required final bool isOwner,
      required final MinimalUser owner,
      required final MinimalEvent event,
      final Position? position,
      @JsonKey(name: "taken_date_time") required final DateTime? takenDateTime,
      @JsonKey(name: "uploaded_date_time")
      required final DateTime uploadDateTime}) = _$EventImageDetailsImpl;

  factory _EventImageDetails.fromJson(Map<String, dynamic> json) =
      _$EventImageDetailsImpl.fromJson;

  @override
  bool get isOwner;
  @override
  MinimalUser get owner;
  @override
  MinimalEvent get event;
  @override
  Position? get position;
  @override
  @JsonKey(name: "taken_date_time")
  DateTime? get takenDateTime;
  @override
  @JsonKey(name: "uploaded_date_time")
  DateTime get uploadDateTime;
  @override
  @JsonKey(ignore: true)
  _$$EventImageDetailsImplCopyWith<_$EventImageDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
