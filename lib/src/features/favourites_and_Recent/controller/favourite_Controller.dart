import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:my_music_player/src/features/favourites_and_Recent/repo/recents_repository.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../../res/const.dart';
import '../../../common/repositories/song_repository.dart';
import '../repo/favorites_repository.dart';

final favoriteProvider = StateProvider.family<bool, String>((ref, songId) {
  final songRepo = SongRepository();
  return songRepo.isFavorite(songId);
});

final favoriteSongsProvider = FutureProvider<List<SongModel>>((ref) async {
  final repo = FavoritesRepository();
  return repo.fetchFavorites();
});
final recentsSongsProvider = FutureProvider<List<SongModel>>((ref) async {
  final repo = RecentsRepository();
  return repo.fetchRecents();
});
