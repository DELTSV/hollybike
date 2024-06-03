// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventDetails _$EventDetailsFromJson(Map<String, dynamic> json) {
  return _EventDetails.fromJson(json);
}

/// @nodoc
mixin _$EventDetails {
  Event get event => throw _privateConstructorUsedError;
  EventCallerParticipation get callerParticipation =>
      throw _privateConstructorUsedError;
  List<EventParticipation> get previewParticipants =>
      throw _privateConstructorUsedError;
  int get previewParticipantsCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventDetailsCopyWith<EventDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventDetailsCopyWith<$Res> {
  factory $EventDetailsCopyWith(
          EventDetails value, $Res Function(EventDetails) then) =
      _$EventDetailsCopyWithImpl<$Res, EventDetails>;
  @useResult
  $Res call(
      {Event event,
      EventCallerParticipation callerParticipation,
      List<EventParticipation> previewParticipants,
      int previewParticipantsCount});

  $EventCopyWith<$Res> get event;
  $EventCallerParticipationCopyWith<$Res> get callerParticipation;
}

/// @nodoc
class _$EventDetailsCopyWithImpl<$Res, $Val extends EventDetails>
    implements $EventDetailsCopyWith<$Res> {
  _$EventDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? callerParticipation = null,
    Object? previewParticipants = null,
    Object? previewParticipantsCount = null,
  }) {
    return _then(_value.copyWith(
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as Event,
      callerParticipation: null == callerParticipation
          ? _value.callerParticipation
          : callerParticipation // ignore: cast_nullable_to_non_nullable
              as EventCallerParticipation,
      previewParticipants: null == previewParticipants
          ? _value.previewParticipants
          : previewParticipants // ignore: cast_nullable_to_non_nullable
              as List<EventParticipation>,
      previewParticipantsCount: null == previewParticipantsCount
          ? _value.previewParticipantsCount
          : previewParticipantsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $EventCopyWith<$Res> get event {
    return $EventCopyWith<$Res>(_value.event, (value) {
      return _then(_value.copyWith(event: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $EventCallerParticipationCopyWith<$Res> get callerParticipation {
    return $EventCallerParticipationCopyWith<$Res>(_value.callerParticipation,
        (value) {
      return _then(_value.copyWith(callerParticipation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EventDetailsImplCopyWith<$Res>
    implements $EventDetailsCopyWith<$Res> {
  factory _$$EventDetailsImplCopyWith(
          _$EventDetailsImpl value, $Res Function(_$EventDetailsImpl) then) =
      __$$EventDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Event event,
      EventCallerParticipation callerParticipation,
      List<EventParticipation> previewParticipants,
      int previewParticipantsCount});

  @override
  $EventCopyWith<$Res> get event;
  @override
  $EventCallerParticipationCopyWith<$Res> get callerParticipation;
}

/// @nodoc
class __$$EventDetailsImplCopyWithImpl<$Res>
    extends _$EventDetailsCopyWithImpl<$Res, _$EventDetailsImpl>
    implements _$$EventDetailsImplCopyWith<$Res> {
  __$$EventDetailsImplCopyWithImpl(
      _$EventDetailsImpl _value, $Res Function(_$EventDetailsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? callerParticipation = null,
    Object? previewParticipants = null,
    Object? previewParticipantsCount = null,
  }) {
    return _then(_$EventDetailsImpl(
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as Event,
      callerParticipation: null == callerParticipation
          ? _value.callerParticipation
          : callerParticipation // ignore: cast_nullable_to_non_nullable
              as EventCallerParticipation,
      previewParticipants: null == previewParticipants
          ? _value._previewParticipants
          : previewParticipants // ignore: cast_nullable_to_non_nullable
              as List<EventParticipation>,
      previewParticipantsCount: null == previewParticipantsCount
          ? _value.previewParticipantsCount
          : previewParticipantsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventDetailsImpl implements _EventDetails {
  const _$EventDetailsImpl(
      {required this.event,
      required this.callerParticipation,
      required final List<EventParticipation> previewParticipants,
      required this.previewParticipantsCount})
      : _previewParticipants = previewParticipants;

  factory _$EventDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventDetailsImplFromJson(json);

  @override
  final Event event;
  @override
  final EventCallerParticipation callerParticipation;
  final List<EventParticipation> _previewParticipants;
  @override
  List<EventParticipation> get previewParticipants {
    if (_previewParticipants is EqualUnmodifiableListView)
      return _previewParticipants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_previewParticipants);
  }

  @override
  final int previewParticipantsCount;

  @override
  String toString() {
    return 'EventDetails(event: $event, callerParticipation: $callerParticipation, previewParticipants: $previewParticipants, previewParticipantsCount: $previewParticipantsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventDetailsImpl &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.callerParticipation, callerParticipation) ||
                other.callerParticipation == callerParticipation) &&
            const DeepCollectionEquality()
                .equals(other._previewParticipants, _previewParticipants) &&
            (identical(
                    other.previewParticipantsCount, previewParticipantsCount) ||
                other.previewParticipantsCount == previewParticipantsCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      event,
      callerParticipation,
      const DeepCollectionEquality().hash(_previewParticipants),
      previewParticipantsCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventDetailsImplCopyWith<_$EventDetailsImpl> get copyWith =>
      __$$EventDetailsImplCopyWithImpl<_$EventDetailsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventDetailsImplToJson(
      this,
    );
  }
}

abstract class _EventDetails implements EventDetails {
  const factory _EventDetails(
      {required final Event event,
      required final EventCallerParticipation callerParticipation,
      required final List<EventParticipation> previewParticipants,
      required final int previewParticipantsCount}) = _$EventDetailsImpl;

  factory _EventDetails.fromJson(Map<String, dynamic> json) =
      _$EventDetailsImpl.fromJson;

  @override
  Event get event;
  @override
  EventCallerParticipation get callerParticipation;
  @override
  List<EventParticipation> get previewParticipants;
  @override
  int get previewParticipantsCount;
  @override
  @JsonKey(ignore: true)
  _$$EventDetailsImplCopyWith<_$EventDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
