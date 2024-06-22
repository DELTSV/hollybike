import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/profile/bloc/profile_api.dart';
import 'package:hollybike/shared/types/paginated_list.dart';
import 'package:hollybike/user/types/minimal_user.dart';

import '../types/profile.dart';

class ProfileRepository {
  final ProfileApi profileApi;

  ProfileRepository({
    required this.profileApi,
  });

  Future<Profile> getSessionProfile(AuthSession session) async {
    return profileApi.getSessionProfile(session);
  }

  Future<MinimalUser> getIdProfile(AuthSession currentSession, int id) async {
    return profileApi.getIdProfile(currentSession, id);
  }

  Future<PaginatedList<MinimalUser>> searchProfiles(
    AuthSession currentSession,
    int? page,
    int eventsPerPage,
    String query,
  ) async {
    return profileApi.searchUsers(
      currentSession,
      page ?? 0,
      eventsPerPage,
      query,
    );
  }
}
