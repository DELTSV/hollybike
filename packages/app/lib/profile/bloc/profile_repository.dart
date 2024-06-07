import 'package:hollybike/auth/bloc/auth_session_repository.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/auth/types/expired_token_exception.dart';
import 'package:hollybike/profile/bloc/profile_api.dart';
import 'package:hollybike/profile/bloc/profile_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../types/profile.dart';

class ProfileRepository {
  final ProfileApi profileApi;

  ProfileRepository({
    required this.profileApi,
  });

  Future<Profile> getSessionProfile(AuthSession session) async {
    return profileApi.getSessionProfile(session);
  }
}
