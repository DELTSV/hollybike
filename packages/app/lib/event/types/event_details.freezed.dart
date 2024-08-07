/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
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
  MinimalJourney? get journey => throw _privateConstructorUsedError;
  EventCallerParticipation? get callerParticipation =>
      throw _privateConstructorUsedError;
  List<EventParticipation> get previewParticipants =>
      throw _privateConstructorUsedError;
  int get previewParticipantsCount => throw _privateConstructorUsedError;
  List<EventExpense>? get expenses => throw _privateConstructorUsedError;
  int? get totalExpense => throw _privateConstructorUsedError;

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
      MinimalJourney? journey,
      EventCallerParticipation? callerParticipation,
      List<EventParticipation> previewParticipants,
      int previewParticipantsCount,
      List<EventExpense>? expenses,
      int? totalExpense});

  $EventCopyWith<$Res> get event;
  $MinimalJourneyCopyWith<$Res>? get journey;
  $EventCallerParticipationCopyWith<$Res>? get callerParticipation;
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
    Object? journey = freezed,
    Object? callerParticipation = freezed,
    Object? previewParticipants = null,
    Object? previewParticipantsCount = null,
    Object? expenses = freezed,
    Object? totalExpense = freezed,
  }) {
    return _then(_value.copyWith(
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as Event,
      journey: freezed == journey
          ? _value.journey
          : journey // ignore: cast_nullable_to_non_nullable
              as MinimalJourney?,
      callerParticipation: freezed == callerParticipation
          ? _value.callerParticipation
          : callerParticipation // ignore: cast_nullable_to_non_nullable
              as EventCallerParticipation?,
      previewParticipants: null == previewParticipants
          ? _value.previewParticipants
          : previewParticipants // ignore: cast_nullable_to_non_nullable
              as List<EventParticipation>,
      previewParticipantsCount: null == previewParticipantsCount
          ? _value.previewParticipantsCount
          : previewParticipantsCount // ignore: cast_nullable_to_non_nullable
              as int,
      expenses: freezed == expenses
          ? _value.expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as List<EventExpense>?,
      totalExpense: freezed == totalExpense
          ? _value.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as int?,
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
  $MinimalJourneyCopyWith<$Res>? get journey {
    if (_value.journey == null) {
      return null;
    }

    return $MinimalJourneyCopyWith<$Res>(_value.journey!, (value) {
      return _then(_value.copyWith(journey: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $EventCallerParticipationCopyWith<$Res>? get callerParticipation {
    if (_value.callerParticipation == null) {
      return null;
    }

    return $EventCallerParticipationCopyWith<$Res>(_value.callerParticipation!,
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
      MinimalJourney? journey,
      EventCallerParticipation? callerParticipation,
      List<EventParticipation> previewParticipants,
      int previewParticipantsCount,
      List<EventExpense>? expenses,
      int? totalExpense});

  @override
  $EventCopyWith<$Res> get event;
  @override
  $MinimalJourneyCopyWith<$Res>? get journey;
  @override
  $EventCallerParticipationCopyWith<$Res>? get callerParticipation;
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
    Object? journey = freezed,
    Object? callerParticipation = freezed,
    Object? previewParticipants = null,
    Object? previewParticipantsCount = null,
    Object? expenses = freezed,
    Object? totalExpense = freezed,
  }) {
    return _then(_$EventDetailsImpl(
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as Event,
      journey: freezed == journey
          ? _value.journey
          : journey // ignore: cast_nullable_to_non_nullable
              as MinimalJourney?,
      callerParticipation: freezed == callerParticipation
          ? _value.callerParticipation
          : callerParticipation // ignore: cast_nullable_to_non_nullable
              as EventCallerParticipation?,
      previewParticipants: null == previewParticipants
          ? _value._previewParticipants
          : previewParticipants // ignore: cast_nullable_to_non_nullable
              as List<EventParticipation>,
      previewParticipantsCount: null == previewParticipantsCount
          ? _value.previewParticipantsCount
          : previewParticipantsCount // ignore: cast_nullable_to_non_nullable
              as int,
      expenses: freezed == expenses
          ? _value._expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as List<EventExpense>?,
      totalExpense: freezed == totalExpense
          ? _value.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventDetailsImpl extends _EventDetails {
  const _$EventDetailsImpl(
      {required this.event,
      required this.journey,
      required this.callerParticipation,
      required final List<EventParticipation> previewParticipants,
      required this.previewParticipantsCount,
      required final List<EventExpense>? expenses,
      required this.totalExpense})
      : _previewParticipants = previewParticipants,
        _expenses = expenses,
        super._();

  factory _$EventDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventDetailsImplFromJson(json);

  @override
  final Event event;
  @override
  final MinimalJourney? journey;
  @override
  final EventCallerParticipation? callerParticipation;
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
  final List<EventExpense>? _expenses;
  @override
  List<EventExpense>? get expenses {
    final value = _expenses;
    if (value == null) return null;
    if (_expenses is EqualUnmodifiableListView) return _expenses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? totalExpense;

  @override
  String toString() {
    return 'EventDetails(event: $event, journey: $journey, callerParticipation: $callerParticipation, previewParticipants: $previewParticipants, previewParticipantsCount: $previewParticipantsCount, expenses: $expenses, totalExpense: $totalExpense)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventDetailsImpl &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.journey, journey) || other.journey == journey) &&
            (identical(other.callerParticipation, callerParticipation) ||
                other.callerParticipation == callerParticipation) &&
            const DeepCollectionEquality()
                .equals(other._previewParticipants, _previewParticipants) &&
            (identical(
                    other.previewParticipantsCount, previewParticipantsCount) ||
                other.previewParticipantsCount == previewParticipantsCount) &&
            const DeepCollectionEquality().equals(other._expenses, _expenses) &&
            (identical(other.totalExpense, totalExpense) ||
                other.totalExpense == totalExpense));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      event,
      journey,
      callerParticipation,
      const DeepCollectionEquality().hash(_previewParticipants),
      previewParticipantsCount,
      const DeepCollectionEquality().hash(_expenses),
      totalExpense);

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

abstract class _EventDetails extends EventDetails {
  const factory _EventDetails(
      {required final Event event,
      required final MinimalJourney? journey,
      required final EventCallerParticipation? callerParticipation,
      required final List<EventParticipation> previewParticipants,
      required final int previewParticipantsCount,
      required final List<EventExpense>? expenses,
      required final int? totalExpense}) = _$EventDetailsImpl;
  const _EventDetails._() : super._();

  factory _EventDetails.fromJson(Map<String, dynamic> json) =
      _$EventDetailsImpl.fromJson;

  @override
  Event get event;
  @override
  MinimalJourney? get journey;
  @override
  EventCallerParticipation? get callerParticipation;
  @override
  List<EventParticipation> get previewParticipants;
  @override
  int get previewParticipantsCount;
  @override
  List<EventExpense>? get expenses;
  @override
  int? get totalExpense;
  @override
  @JsonKey(ignore: true)
  _$$EventDetailsImplCopyWith<_$EventDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
