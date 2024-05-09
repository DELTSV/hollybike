import 'package:hollybike/auth/bloc/auth_session_repository.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/auth/types/expired_token_exception.dart';
import 'package:hollybike/profile/bloc/profile_api.dart';
import 'package:hollybike/profile/bloc/profile_bloc.dart';

import '../types/profile.dart';

class ProfileRepository {
  final ProfileBloc profileBloc;
  final ProfileApi profileApi;
  final AuthSessionRepository authSessionRepository;

  const ProfileRepository({
    required this.profileBloc,
    required this.profileApi,
    required this.authSessionRepository,
  });

  Future<Profile> getSessionProfile(AuthSession session) async {
    final storedProfile = profileBloc.state.findSessionProfile(session);
    if (storedProfile != null) return storedProfile;

    try {
      final fetchedProfile = await profileApi.getSessionProfile(session);
      profileBloc.add(ProfileSave(session: session, profile: fetchedProfile));
      return fetchedProfile;
    } on ExpiredTokenException catch(_) {
      authSessionRepository.sessionExpired(session);
      rethrow;
    }
  }
}
