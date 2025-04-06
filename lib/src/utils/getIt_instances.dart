import 'package:get_it/get_it.dart';

import 'package:on_audio_query/on_audio_query.dart';

import '../features/favourites_and_Recent/repo/favorites_repository.dart';
import '../features/player/repo/player_repository.dart';
import '../features/favourites_and_Recent/repo/recents_repository.dart';
import '../common/repositories/song_repository.dart';
import '../common/repositories/theme_repository.dart';
import '../features/home/repo/homeRepository.dart';

final sl = GetIt.instance;

void init() {
  // // Bloc
  // sl.registerFactory(() => ThemeBloc(repository: sl()));
  // sl.registerFactory(() => HomeBloc(repository: sl()));
  // sl.registerFactory(() => PlayerBloc(repository: sl()));
  // sl.registerFactory(() => SongBloc(repository: sl()));
  // sl.registerFactory(() => FavoritesBloc(repository: sl()));
  // sl.registerFactory(() => RecentsBloc(repository: sl()));
  // sl.registerFactory(() => SearchBloc(repository: sl()));
  // // Cubit
  // sl.registerFactory(() => ScanCubit());
  // sl.registerFactory(() => PlaylistsCubit());

  // Repository
  sl.registerLazySingleton(() => ThemeRepository());
  sl.registerLazySingleton(() => HomeRepository());
  // sl.registerLazySingleton<MusicPlayer>(
  //       () => JustAudioPlayer(),
  // );
  sl.registerLazySingleton(() => SongRepository());
  sl.registerLazySingleton(() => FavoritesRepository());
  sl.registerLazySingleton(() => RecentsRepository());
  // sl.registerLazySingleton(() => SearchRepository());

  // Third Party
  sl.registerLazySingleton(() => OnAudioQuery());
}

