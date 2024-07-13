import 'dart:async';
import 'dart:io';

import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/profile/services/profile_api.dart';
import 'package:hollybike/shared/types/paginated_list.dart';
import 'package:hollybike/user/types/minimal_user.dart';

import '../types/profile.dart';

class ProfileRepository {
  final Map<AuthSession, Profile> profiles;
  final Map<AuthSession, List<MinimalUser>> users;
  final ProfileApi profileApi;

  ProfileRepository({
    required this.profileApi,
  })  : profiles = {},
        users = {};

  FutureOr<Profile> getProfile(AuthSession session) async {
    final cachedProfile = profiles[session];
    if (cachedProfile is Profile) return cachedProfile;
    final profile = await profileApi.getProfile(session);
    profiles[session] = profile;
    return profile;
  }

  FutureOr<MinimalUser> getUserById(int id, AuthSession currentSession) async {
    try {
      bool isSearchedProfile(MinimalUser profile) => profile.id == id;
      return profiles.values
          .map((sessionProfile) => sessionProfile.toMinimalUser())
          .firstWhere(
            isSearchedProfile,
            orElse: () => users[currentSession]!.firstWhere(isSearchedProfile),
          );
    } catch (_) {
      final user = await profileApi.getUserById(id);
      users[currentSession] = [...?users[currentSession], user];
      return user;
    }
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

  Future<Profile> updateMyProfile(
    String username,
    String? description,
    File? image,
  ) async {
    final updatedProfile = await profileApi.updateProfile(
      username,
      description,
      image,
    );

    return updatedProfile;
  }
}
