/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventExpense _$EventExpenseFromJson(Map<String, dynamic> json) {
  return _EventExpense.fromJson(json);
}

/// @nodoc
mixin _$EventExpense {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  String? get proof => throw _privateConstructorUsedError;
  @JsonKey(name: 'proof_key')
  String? get proofKey => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventExpenseCopyWith<EventExpense> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventExpenseCopyWith<$Res> {
  factory $EventExpenseCopyWith(
          EventExpense value, $Res Function(EventExpense) then) =
      _$EventExpenseCopyWithImpl<$Res, EventExpense>;
  @useResult
  $Res call(
      {int id,
      String name,
      String? description,
      DateTime date,
      int amount,
      String? proof,
      @JsonKey(name: 'proof_key') String? proofKey});
}

/// @nodoc
class _$EventExpenseCopyWithImpl<$Res, $Val extends EventExpense>
    implements $EventExpenseCopyWith<$Res> {
  _$EventExpenseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? date = null,
    Object? amount = null,
    Object? proof = freezed,
    Object? proofKey = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      proof: freezed == proof
          ? _value.proof
          : proof // ignore: cast_nullable_to_non_nullable
              as String?,
      proofKey: freezed == proofKey
          ? _value.proofKey
          : proofKey // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventExpenseImplCopyWith<$Res>
    implements $EventExpenseCopyWith<$Res> {
  factory _$$EventExpenseImplCopyWith(
          _$EventExpenseImpl value, $Res Function(_$EventExpenseImpl) then) =
      __$$EventExpenseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String? description,
      DateTime date,
      int amount,
      String? proof,
      @JsonKey(name: 'proof_key') String? proofKey});
}

/// @nodoc
class __$$EventExpenseImplCopyWithImpl<$Res>
    extends _$EventExpenseCopyWithImpl<$Res, _$EventExpenseImpl>
    implements _$$EventExpenseImplCopyWith<$Res> {
  __$$EventExpenseImplCopyWithImpl(
      _$EventExpenseImpl _value, $Res Function(_$EventExpenseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? date = null,
    Object? amount = null,
    Object? proof = freezed,
    Object? proofKey = freezed,
  }) {
    return _then(_$EventExpenseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      proof: freezed == proof
          ? _value.proof
          : proof // ignore: cast_nullable_to_non_nullable
              as String?,
      proofKey: freezed == proofKey
          ? _value.proofKey
          : proofKey // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventExpenseImpl implements _EventExpense {
  const _$EventExpenseImpl(
      {required this.id,
      required this.name,
      this.description,
      required this.date,
      required this.amount,
      this.proof,
      @JsonKey(name: 'proof_key') this.proofKey});

  factory _$EventExpenseImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventExpenseImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final DateTime date;
  @override
  final int amount;
  @override
  final String? proof;
  @override
  @JsonKey(name: 'proof_key')
  final String? proofKey;

  @override
  String toString() {
    return 'EventExpense(id: $id, name: $name, description: $description, date: $date, amount: $amount, proof: $proof, proofKey: $proofKey)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventExpenseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.proof, proof) || other.proof == proof) &&
            (identical(other.proofKey, proofKey) ||
                other.proofKey == proofKey));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, description, date, amount, proof, proofKey);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventExpenseImplCopyWith<_$EventExpenseImpl> get copyWith =>
      __$$EventExpenseImplCopyWithImpl<_$EventExpenseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventExpenseImplToJson(
      this,
    );
  }
}

abstract class _EventExpense implements EventExpense {
  const factory _EventExpense(
      {required final int id,
      required final String name,
      final String? description,
      required final DateTime date,
      required final int amount,
      final String? proof,
      @JsonKey(name: 'proof_key') final String? proofKey}) = _$EventExpenseImpl;

  factory _EventExpense.fromJson(Map<String, dynamic> json) =
      _$EventExpenseImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  DateTime get date;
  @override
  int get amount;
  @override
  String? get proof;
  @override
  @JsonKey(name: 'proof_key')
  String? get proofKey;
  @override
  @JsonKey(ignore: true)
  _$$EventExpenseImplCopyWith<_$EventExpenseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
