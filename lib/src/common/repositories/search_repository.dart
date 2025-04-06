import 'package:on_audio_query/on_audio_query.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'search_repository.dart';

final searchRepositoryProvider = Provider((ref) => SearchRepository());

final searchControllerProvider = StateNotifierProvider<SearchController, AsyncValue<List<SongModel>>>(
  (ref) => SearchController(ref.watch(searchRepositoryProvider)),
);

class SearchController extends StateNotifier<AsyncValue<List<SongModel>>> {
  final SearchRepository searchRepository;

  SearchController(this.searchRepository) : super(const AsyncValue.data([]));

  Future<void> searchSongs(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    state = const AsyncValue.loading();
    try {
      final songs = await searchRepository.search(query);
      state = AsyncValue.data(songs);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

class SearchRepository {
  final _audioQuery = OnAudioQuery();

  Future<List<SongModel>> search(String query) async {
    final List songs = await _audioQuery.queryWithFilters(
      query,
      WithFiltersType.AUDIOS,
    );

    return songs.map((e) => SongModel(e)).toList();
  }
}
