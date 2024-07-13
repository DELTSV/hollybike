import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/shared/types/json_map.dart';

part 'update_password.freezed.dart';

part 'update_password.g.dart';

@freezed
class UpdatePassword with _$UpdatePassword {
  const factory UpdatePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordAgain,
  }) = _UpdatePassword;

  factory UpdatePassword.fromJson(JsonMap json) => _$UpdatePasswordFromJson(json);
}
