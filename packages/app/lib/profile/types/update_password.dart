import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/shared/types/json_map.dart';

part 'update_password.freezed.dart';

part 'update_password.g.dart';

@freezed
class UpdatePassword with _$UpdatePassword {
  const factory UpdatePassword({
    @JsonKey(name: 'old_password') required String oldPassword,
    @JsonKey(name: 'new_password') required String newPassword,
    @JsonKey(name: 'new_password_again') required String newPasswordAgain,
  }) = _UpdatePassword;

  factory UpdatePassword.fromJson(JsonMap json) => _$UpdatePasswordFromJson(json);
}
