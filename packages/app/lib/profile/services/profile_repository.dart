import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/profile/services/profile_api.dart';
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

  Future<MinimalUser> getIdProfile(int id) async {
    return profileApi.getIdProfile(id);
  }

  Future<PaginatedList<MinimalUser>> searchProfiles(
    int? page,
    int eventsPerPage,
    String query,
  ) async {
    return profileApi.searchUsers(
      page ?? 0,
      eventsPerPage,
      query,
    );
  }
}
