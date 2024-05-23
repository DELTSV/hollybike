// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateEventDTO _$CreateEventDTOFromJson(Map<String, dynamic> json) {
  return _CreateEventDTO.fromJson(json);
}

/// @nodoc
mixin _$CreateEventDTO {
  String get name => throw _privateConstructorUsedError;
  @JsonKey(toJson: _toJson)
  DateTime get startDate => throw _privateConstructorUsedError;
  @JsonKey(toJson: _toJson)
  DateTime? get endDate => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateEventDTOCopyWith<CreateEventDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateEventDTOCopyWith<$Res> {
  factory $CreateEventDTOCopyWith(
          CreateEventDTO value, $Res Function(CreateEventDTO) then) =
      _$CreateEventDTOCopyWithImpl<$Res, CreateEventDTO>;
  @useResult
  $Res call(
      {String name,
      @JsonKey(toJson: _toJson) DateTime startDate,
      @JsonKey(toJson: _toJson) DateTime? endDate,
      String? description});
}

/// @nodoc
class _$CreateEventDTOCopyWithImpl<$Res, $Val extends CreateEventDTO>
    implements $CreateEventDTOCopyWith<$Res> {
  _$CreateEventDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateEventDTOImplCopyWith<$Res>
    implements $CreateEventDTOCopyWith<$Res> {
  factory _$$CreateEventDTOImplCopyWith(_$CreateEventDTOImpl value,
          $Res Function(_$CreateEventDTOImpl) then) =
      __$$CreateEventDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      @JsonKey(toJson: _toJson) DateTime startDate,
      @JsonKey(toJson: _toJson) DateTime? endDate,
      String? description});
}

/// @nodoc
class __$$CreateEventDTOImplCopyWithImpl<$Res>
    extends _$CreateEventDTOCopyWithImpl<$Res, _$CreateEventDTOImpl>
    implements _$$CreateEventDTOImplCopyWith<$Res> {
  __$$CreateEventDTOImplCopyWithImpl(
      _$CreateEventDTOImpl _value, $Res Function(_$CreateEventDTOImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? description = freezed,
  }) {
    return _then(_$CreateEventDTOImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateEventDTOImpl implements _CreateEventDTO {
  const _$CreateEventDTOImpl(
      {required this.name,
      @JsonKey(toJson: _toJson) required this.startDate,
      @JsonKey(toJson: _toJson) this.endDate,
      this.description});

  factory _$CreateEventDTOImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateEventDTOImplFromJson(json);

  @override
  final String name;
  @override
  @JsonKey(toJson: _toJson)
  final DateTime startDate;
  @override
  @JsonKey(toJson: _toJson)
  final DateTime? endDate;
  @override
  final String? description;

  @override
  String toString() {
    return 'CreateEventDTO(name: $name, startDate: $startDate, endDate: $endDate, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateEventDTOImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, startDate, endDate, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateEventDTOImplCopyWith<_$CreateEventDTOImpl> get copyWith =>
      __$$CreateEventDTOImplCopyWithImpl<_$CreateEventDTOImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateEventDTOImplToJson(
      this,
    );
  }
}

abstract class _CreateEventDTO implements CreateEventDTO {
  const factory _CreateEventDTO(
      {required final String name,
      @JsonKey(toJson: _toJson) required final DateTime startDate,
      @JsonKey(toJson: _toJson) final DateTime? endDate,
      final String? description}) = _$CreateEventDTOImpl;

  factory _CreateEventDTO.fromJson(Map<String, dynamic> json) =
      _$CreateEventDTOImpl.fromJson;

  @override
  String get name;
  @override
  @JsonKey(toJson: _toJson)
  DateTime get startDate;
  @override
  @JsonKey(toJson: _toJson)
  DateTime? get endDate;
  @override
  String? get description;
  @override
  @JsonKey(ignore: true)
  _$$CreateEventDTOImplCopyWith<_$CreateEventDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
