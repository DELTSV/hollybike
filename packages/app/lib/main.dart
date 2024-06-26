import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/app/app.dart';
import 'package:hollybike/auth/bloc/auth_api.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/bloc/auth_persistence.dart';
import 'package:hollybike/auth/bloc/auth_repository.dart';
import 'package:hollybike/auth/bloc/auth_session_repository.dart';
import 'package:hollybike/event/bloc/event_candidates_bloc/event_candidates_bloc.dart';
import 'package:hollybike/event/bloc/event_candidates_bloc/event_candidates_event.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_images_bloc.dart';
import 'package:hollybike/event/bloc/event_journey_bloc/event_journey_bloc.dart';
import 'package:hollybike/event/bloc/event_participations_bloc/event_participations_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/archived_events_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/future_events_bloc.dart';
import 'package:hollybike/notification/bloc/notification_bloc.dart';
import 'package:hollybike/notification/bloc/notification_repository.dart';
import 'package:hollybike/positions/bloc/my_position_bloc.dart';
import 'package:hollybike/positions/bloc/my_position_event.dart';
import 'package:hollybike/positions/service/my_position_locator.dart';
import 'package:hollybike/profile/services/profile_api.dart';
import 'package:hollybike/profile/bloc/profile_bloc.dart';
import 'package:hollybike/profile/services/profile_repository.dart';
import 'package:hollybike/search/bloc/search_bloc.dart';
import 'package:hollybike/search/bloc/search_event.dart';
import 'package:hollybike/shared/http/dio_client.dart';
import 'package:hollybike/theme/bloc/theme_bloc.dart';
import 'package:provider/provider.dart';
import 'event/bloc/event_details_bloc/event_details_bloc.dart';
import 'event/bloc/event_details_bloc/event_details_event.dart';
import 'event/bloc/event_images_bloc/event_image_details_bloc.dart';
import 'event/bloc/event_images_bloc/event_my_images_bloc.dart';
import 'event/bloc/event_participations_bloc/event_participations_event.dart';
import 'event/bloc/events_bloc/events_event.dart';
import 'event/bloc/events_bloc/user_events_bloc.dart';
import 'event/services/event/event_api.dart';
import 'event/services/event/event_repository.dart';
import 'event/services/image/image_api.dart';
import 'event/services/image/image_repository.dart';
import 'event/services/participation/event_participation_api.dart';
import 'event/services/participation/event_participation_repository.dart';
import 'journey/bloc/journeys_library_bloc/journeys_library_bloc.dart';
import 'journey/service/journey_api.dart';
import 'journey/service/journey_repository.dart';

Future<void> infiniteDelay() async {
  final completer = Completer<void>();
  return completer.future;
}

void main() {
  NetworkImageCache();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class NetworkImageCache extends WidgetsFlutterBinding {
  @override
  ImageCache createImageCache() {
    ImageCache imageCache = super.createImageCache();
    imageCache.maximumSizeBytes = 1024 * 1024 * 500;
    return imageCache;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AuthPersistence(),
      child: Provider(
        create: (context) => DioClient(
          authPersistence: Provider.of<AuthPersistence>(context, listen: false),
        ),
        child: Builder(builder: (context) {
          return BlocProvider(
            create: (context) => NotificationBloc(),
            child: MultiRepositoryProvider(
              providers: [
                RepositoryProvider(
                  create: (context) => NotificationRepository(
                    notificationBloc:
                        BlocProvider.of<NotificationBloc>(context),
                  ),
                ),
                RepositoryProvider(
                  create: (context) => AuthRepository(
                    authApi: AuthApi(),
                    authPersistence:
                        Provider.of<AuthPersistence>(context, listen: false),
                  ),
                ),
                RepositoryProvider(
                  create: (context) => EventRepository(
                    eventApi: EventApi(
                      client: RepositoryProvider.of<DioClient>(context),
                    ),
                  ),
                ),
                RepositoryProvider(
                  create: (context) => EventParticipationRepository(
                    eventParticipationsApi: EventParticipationsApi(
                      client: RepositoryProvider.of<DioClient>(context),
                    ),
                  ),
                ),
                RepositoryProvider(
                  create: (context) => AuthSessionRepository(),
                ),
                RepositoryProvider(
                  create: (context) => ProfileRepository(
                    profileApi: ProfileApi(
                      client: RepositoryProvider.of<DioClient>(context),
                    ),
                  ),
                ),
                RepositoryProvider(
                  create: (context) => ImageRepository(
                    imageApi: ImageApi(
                      client: RepositoryProvider.of<DioClient>(context),
                    ),
                  ),
                ),
                RepositoryProvider(
                  create: (context) => JourneyRepository(
                    journeyApi: JourneyApi(
                      client: RepositoryProvider.of<DioClient>(context),
                    ),
                  ),
                ),
              ],
              child: MultiBlocProvider(
                providers: [
                  BlocProvider<AuthBloc>(
                    create: (context) => AuthBloc(
                      authRepository:
                          RepositoryProvider.of<AuthRepository>(context),
                      authSessionRepository:
                          RepositoryProvider.of<AuthSessionRepository>(context),
                      profileRepository:
                          RepositoryProvider.of<ProfileRepository>(context),
                      notificationRepository:
                          RepositoryProvider.of<NotificationRepository>(
                              context),
                    ),
                  ),
                  BlocProvider<ThemeBloc>(
                    create: (context) => ThemeBloc(),
                  ),
                  BlocProvider<ProfileBloc>(
                    lazy: false,
                    create: (context) => ProfileBloc(
                      authRepository:
                          RepositoryProvider.of<AuthRepository>(context),
                      authSessionRepository:
                          RepositoryProvider.of<AuthSessionRepository>(context),
                      profileRepository:
                          RepositoryProvider.of<ProfileRepository>(context),
                    )..add(SubscribeToCurrentSessionChange()),
                  ),
                  BlocProvider<FutureEventsBloc>(
                    create: (context) => FutureEventsBloc(
                      eventRepository:
                          RepositoryProvider.of<EventRepository>(context),
                    )..add(SubscribeToEvents()),
                  ),
                  BlocProvider<ArchivedEventsBloc>(
                    create: (context) => ArchivedEventsBloc(
                      eventRepository:
                          RepositoryProvider.of<EventRepository>(context),
                    )..add(SubscribeToEvents()),
                  ),
                  BlocProvider<UserEventsBloc>(
                    create: (context) => UserEventsBloc(
                      eventRepository:
                          RepositoryProvider.of<EventRepository>(context),
                    )..add(SubscribeToEvents()),
                  ),
                  BlocProvider<EventDetailsBloc>(
                    create: (context) => EventDetailsBloc(
                      eventRepository:
                          RepositoryProvider.of<EventRepository>(context),
                    )..add(SubscribeToEvent()),
                  ),
                  BlocProvider<EventParticipationBloc>(
                    create: (context) => EventParticipationBloc(
                      eventParticipationsRepository:
                          RepositoryProvider.of<EventParticipationRepository>(
                        context,
                      ),
                      eventRepository:
                          RepositoryProvider.of<EventRepository>(context),
                    )..add(SubscribeToEventParticipations()),
                  ),
                  BlocProvider<EventCandidatesBloc>(
                    create: (context) => EventCandidatesBloc(
                      eventParticipationsRepository:
                          RepositoryProvider.of<EventParticipationRepository>(
                        context,
                      ),
                      eventRepository:
                          RepositoryProvider.of<EventRepository>(context),
                    )..add(SubscribeToEventCandidates()),
                  ),
                  BlocProvider<EventImagesBloc>(
                    create: (context) => EventImagesBloc(
                      imageRepository: RepositoryProvider.of<ImageRepository>(
                        context,
                      ),
                    ),
                  ),
                  BlocProvider<EventMyImagesBloc>(
                    create: (context) => EventMyImagesBloc(
                      imageRepository: RepositoryProvider.of<ImageRepository>(
                        context,
                      ),
                      eventRepository: RepositoryProvider.of<EventRepository>(
                        context,
                      ),
                    ),
                  ),
                  BlocProvider<EventImageDetailsBloc>(
                    create: (context) => EventImageDetailsBloc(
                      imageRepository: RepositoryProvider.of<ImageRepository>(
                        context,
                      ),
                    ),
                  ),
                  BlocProvider<EventJourneyBloc>(
                    create: (context) => EventJourneyBloc(
                      journeyRepository:
                          RepositoryProvider.of<JourneyRepository>(
                        context,
                      ),
                      eventRepository: RepositoryProvider.of<EventRepository>(
                        context,
                      ),
                    ),
                  ),
                  BlocProvider<JourneysLibraryBloc>(
                    create: (context) => JourneysLibraryBloc(
                      journeyRepository:
                          RepositoryProvider.of<JourneyRepository>(
                        context,
                      ),
                    ),
                  ),
                  BlocProvider<SearchBloc>(
                    create: (context) => SearchBloc(
                      eventRepository: RepositoryProvider.of<EventRepository>(
                        context,
                      ),
                      profileRepository:
                          RepositoryProvider.of<ProfileRepository>(
                        context,
                      ),
                    )..add(SubscribeToEventsSearch()),
                  ),
                  BlocProvider<MyPositionBloc>(
                    create: (context) => MyPositionBloc(
                      eventRepository: RepositoryProvider.of<EventRepository>(
                        context,
                      ),
                      myPositionLocator: MyPositionLocator(
                        authPersistence: Provider.of<AuthPersistence>(
                          context,
                          listen: false,
                        ),
                      ),
                    )..add(
                        SubscribeToMyPositionUpdates(),
                      ),
                  ),
                ],
                child: App(
                  authPersistence:
                      Provider.of<AuthPersistence>(context, listen: false),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
