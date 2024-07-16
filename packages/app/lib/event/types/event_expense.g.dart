/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventExpenseImpl _$$EventExpenseImplFromJson(Map<String, dynamic> json) =>
    _$EventExpenseImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] as num).toInt(),
      proof: json['proof'] as String?,
      proofKey: json['proof_key'] as String?,
    );

Map<String, dynamic> _$$EventExpenseImplToJson(_$EventExpenseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'date': instance.date.toIso8601String(),
      'amount': instance.amount,
      'proof': instance.proof,
      'proof_key': instance.proofKey,
    };
