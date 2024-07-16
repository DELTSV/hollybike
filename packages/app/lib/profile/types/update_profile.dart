/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/shared/types/json_map.dart';

part 'update_profile.freezed.dart';

part 'update_profile.g.dart';

@freezed
class UpdateProfile with _$UpdateProfile {
  const factory UpdateProfile({
    required String username,
    String? role,
  }) = _UpdateProfile;

  factory UpdateProfile.fromJson(JsonMap json) => _$UpdateProfileFromJson(json);
}
