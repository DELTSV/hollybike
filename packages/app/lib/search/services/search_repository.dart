import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/shared/types/dto_compatible.dart';

import 'package:hollybike/shared/types/paginated_list.dart';

import 'search_api.dart';

class SearchRepository<D, F extends DtoCompatibleFactory<D>> {
  final SearchApi<D, F> searchApi;

  SearchRepository({required this.searchApi});

  Future<PaginatedList<D>> fetchSearch(
    AuthSession session,
    int page,
    int eventsPerPage,
  ) async =>
      await searchApi.getEvents(
        session,
        page,
        eventsPerPage,
      );

  Future<PaginatedList<D>> refreshSearch(
    AuthSession session,
    int eventsPerPage,
  ) async =>
      await searchApi.getEvents(
        session,
        0,
        eventsPerPage,
      );
}
