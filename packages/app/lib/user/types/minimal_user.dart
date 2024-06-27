import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/user/types/user_scope.dart';
import 'package:hollybike/user/types/user_status.dart';

part 'minimal_user.freezed.dart';
part 'minimal_user.g.dart';

@freezed
class MinimalUser with _$MinimalUser {
  const factory MinimalUser({
    required int id,
    required String username,
    required UserScope scope,
    required UserStatus status,
    @JsonKey(name: "profile_picture") String? profilePicture,
  }) = _MinimalUser;

  factory MinimalUser.fromJson(Map<String, dynamic> json) =>
      _$MinimalUserFromJson(json);
}
