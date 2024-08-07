/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_form_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventFormData _$EventFormDataFromJson(Map<String, dynamic> json) {
  return _EventFormData.fromJson(json);
}

/// @nodoc
mixin _$EventFormData {
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(toJson: dateToJson, name: "start_date")
  DateTime get startDate => throw _privateConstructorUsedError;
  @JsonKey(toJson: dateToJson, name: "end_date")
  DateTime? get endDate => throw _privateConstructorUsedError;
  int? get budget => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventFormDataCopyWith<EventFormData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventFormDataCopyWith<$Res> {
  factory $EventFormDataCopyWith(
          EventFormData value, $Res Function(EventFormData) then) =
      _$EventFormDataCopyWithImpl<$Res, EventFormData>;
  @useResult
  $Res call(
      {String name,
      String? description,
      @JsonKey(toJson: dateToJson, name: "start_date") DateTime startDate,
      @JsonKey(toJson: dateToJson, name: "end_date") DateTime? endDate,
      int? budget});
}

/// @nodoc
class _$EventFormDataCopyWithImpl<$Res, $Val extends EventFormData>
    implements $EventFormDataCopyWith<$Res> {
  _$EventFormDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = freezed,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? budget = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      budget: freezed == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventFormDataImplCopyWith<$Res>
    implements $EventFormDataCopyWith<$Res> {
  factory _$$EventFormDataImplCopyWith(
          _$EventFormDataImpl value, $Res Function(_$EventFormDataImpl) then) =
      __$$EventFormDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String? description,
      @JsonKey(toJson: dateToJson, name: "start_date") DateTime startDate,
      @JsonKey(toJson: dateToJson, name: "end_date") DateTime? endDate,
      int? budget});
}

/// @nodoc
class __$$EventFormDataImplCopyWithImpl<$Res>
    extends _$EventFormDataCopyWithImpl<$Res, _$EventFormDataImpl>
    implements _$$EventFormDataImplCopyWith<$Res> {
  __$$EventFormDataImplCopyWithImpl(
      _$EventFormDataImpl _value, $Res Function(_$EventFormDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = freezed,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? budget = freezed,
  }) {
    return _then(_$EventFormDataImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      budget: freezed == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventFormDataImpl extends _EventFormData {
  const _$EventFormDataImpl(
      {required this.name,
      required this.description,
      @JsonKey(toJson: dateToJson, name: "start_date") required this.startDate,
      @JsonKey(toJson: dateToJson, name: "end_date") required this.endDate,
      this.budget})
      : super._();

  factory _$EventFormDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventFormDataImplFromJson(json);

  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(toJson: dateToJson, name: "start_date")
  final DateTime startDate;
  @override
  @JsonKey(toJson: dateToJson, name: "end_date")
  final DateTime? endDate;
  @override
  final int? budget;

  @override
  String toString() {
    return 'EventFormData(name: $name, description: $description, startDate: $startDate, endDate: $endDate, budget: $budget)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventFormDataImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.budget, budget) || other.budget == budget));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, description, startDate, endDate, budget);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventFormDataImplCopyWith<_$EventFormDataImpl> get copyWith =>
      __$$EventFormDataImplCopyWithImpl<_$EventFormDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventFormDataImplToJson(
      this,
    );
  }
}

abstract class _EventFormData extends EventFormData {
  const factory _EventFormData(
      {required final String name,
      required final String? description,
      @JsonKey(toJson: dateToJson, name: "start_date")
      required final DateTime startDate,
      @JsonKey(toJson: dateToJson, name: "end_date")
      required final DateTime? endDate,
      final int? budget}) = _$EventFormDataImpl;
  const _EventFormData._() : super._();

  factory _EventFormData.fromJson(Map<String, dynamic> json) =
      _$EventFormDataImpl.fromJson;

  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(toJson: dateToJson, name: "start_date")
  DateTime get startDate;
  @override
  @JsonKey(toJson: dateToJson, name: "end_date")
  DateTime? get endDate;
  @override
  int? get budget;
  @override
  @JsonKey(ignore: true)
  _$$EventFormDataImplCopyWith<_$EventFormDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
