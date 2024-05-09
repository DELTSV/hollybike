import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/profile/bloc/profile_api.dart';
import 'package:hollybike/profile/bloc/profile_bloc.dart';

import '../types/profile.dart';

class ProfileRepository {
  final ProfileBloc profileBloc;
  final ProfileApi profileApi;

  const ProfileRepository({
    required this.profileBloc,
    required this.profileApi,
  });

  Future<Profile> getSessionProfile(AuthSession session) async {
    final storedProfile = profileBloc.state.findSessionProfile(session);
    if (storedProfile != null) return storedProfile;

    final fetchedProfile = await profileApi.getSessionProfile(session);
    profileBloc.add(ProfileSave(session: session, profile: fetchedProfile));
    return fetchedProfile;
  }
}
