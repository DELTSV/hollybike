import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/shared/types/json_map.dart';

part 'event_expense.freezed.dart';
part 'event_expense.g.dart';

@freezed
class EventExpense with _$EventExpense {
  const factory EventExpense({
    required int id,
    required String name,
    String? description,
    required DateTime date,
    required int amount,
    String? proof,
    @JsonKey(name: 'proof_key') String? proofKey,
  }) = _EventExpense;

  factory EventExpense.fromJson(JsonMap json) =>
      _$EventExpenseFromJson(json);
}
