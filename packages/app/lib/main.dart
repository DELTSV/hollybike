import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hollybike/app/app.dart';
import 'package:hollybike/auth/services/auth_api.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/services/auth_persistence.dart';
import 'package:hollybike/auth/services/auth_repository.dart';
import 'package:hollybike/auth/services/auth_session_repository.dart';
import 'package:hollybike/image/services/image_repository.dart';
import 'package:hollybike/notification/bloc/notification_bloc.dart';
import 'package:hollybike/positions/bloc/my_position/my_position_bloc.dart';
import 'package:hollybike/positions/bloc/my_position/my_position_event.dart';
import 'package:hollybike/positions/service/my_position_locator.dart';
import 'package:hollybike/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:hollybike/profile/services/profile_api.dart';
import 'package:hollybike/profile/services/profile_repository.dart';
import 'package:hollybike/search/bloc/search_bloc.dart';
import 'package:hollybike/search/bloc/search_event.dart';
import 'package:hollybike/shared/http/dio_client.dart';
import 'package:hollybike/shared/http/downloader.dart';
import 'package:hollybike/theme/bloc/theme_bloc.dart';
import 'package:hollybike/user_journey/services/user_journey_api.dart';
import 'package:hollybike/user_journey/services/user_journey_repository.dart';
import 'package:provider/provider.dart';

import 'event/services/event/event_api.dart';
import 'event/services/event/event_repository.dart';
import 'event/services/participation/event_participation_api.dart';
import 'event/services/participation/event_participation_repository.dart';
import 'image/services/image_api.dart';
import 'journey/service/journey_api.dart';
import 'journey/service/journey_repository.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

Future<void> infiniteDelay() async {
  final completer = Completer<void>();
  return completer.future;
}

void main() async {
  NetworkImageCache();
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );

  FlutterNativeSplash.remove();

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setHighRefreshRate();
    });
  }

  Future<void> setHighRefreshRate() async {
    try {
      await FlutterDisplayMode.setHighRefreshRate();
    } on PlatformException catch (_) {
      // Not supported
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AuthPersistence(),
      child: MultiProvider(
        providers: [
          Provider(
            create: (context) => DioClient(
              authPersistence:
                  Provider.of<AuthPersistence>(context, listen: false),
            ),
          ),
          Provider(
            create: (context) => Downloader(
              authPersistence:
                  Provider.of<AuthPersistence>(context, listen: false),
            ),
          ),
        ],
        child: Builder(builder: (context) {
          return MultiRepositoryProvider(
            providers: [
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
                    downloader: RepositoryProvider.of<Downloader>(context),
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
                  authPersistence: Provider.of<AuthPersistence>(
                    context,
                    listen: false,
                  ),
                  profileApi: ProfileApi(
                    client: RepositoryProvider.of<DioClient>(context),
                    authPersistence: Provider.of<AuthPersistence>(context, listen: false),
                  ),
                ),
              ),
              RepositoryProvider(
                create: (context) => ImageRepository(
                  imageApi: ImageApi(
                    client: RepositoryProvider.of<DioClient>(context),
                    downloader: RepositoryProvider.of<Downloader>(context),
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
              RepositoryProvider(
                create: (context) => UserJourneyRepository(
                  userJourneyApi: UserJourneyApi(
                    client: RepositoryProvider.of<DioClient>(context),
                    downloader: RepositoryProvider.of<Downloader>(context),
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
                  ),
                ),
                BlocProvider<NotificationBloc>(
                  create: (context) => NotificationBloc(
                    authRepository:
                        RepositoryProvider.of<AuthRepository>(context),
                  ),
                ),
                BlocProvider<ThemeBloc>(
                  create: (context) => ThemeBloc(),
                ),
                BlocProvider<ProfileBloc>(
                  lazy: false,
                  create: (context) => ProfileBloc(
                    authSessionRepository:
                        RepositoryProvider.of<AuthSessionRepository>(context),
                    profileRepository:
                        RepositoryProvider.of<ProfileRepository>(context),
                  )
                    ..add(SubscribeToCurrentSessionChange())
                    ..add(SubscribeToInvalidatedProfiles()),
                ),
                BlocProvider<SearchBloc>(
                  create: (context) => SearchBloc(
                    eventRepository: RepositoryProvider.of<EventRepository>(
                      context,
                    ),
                    profileRepository: RepositoryProvider.of<ProfileRepository>(
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
          );
        }),
      ),
    );
  }
}
