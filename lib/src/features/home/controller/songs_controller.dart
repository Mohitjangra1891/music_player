import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../repo/homeRepository.dart';

enum SongsStateStatus { loading, success, error }

final songsControllerProvider = StateNotifierProvider<SongsController, SongsState>((ref) {
  final repository = ref.watch(homeRepoProvider);
  return SongsController(repository);
});

class SongsState {
  final List<SongModel> songs;
  final SongsStateStatus status;
  final String? errorMessage;

  SongsState({
    this.songs = const [],
    this.status = SongsStateStatus.loading,
    this.errorMessage,
  });

  SongsState copyWith({
    List<SongModel>? songs,
    SongsStateStatus? status,
    String? errorMessage,
  }) {
    return SongsState(
      songs: songs ?? this.songs,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

class SongsController extends StateNotifier<SongsState> {
  final HomeRepository _homeRepository;

  SongsController(this._homeRepository) : super(SongsState()) {
    fetchSongs();
  }

  Future<void> fetchSongs() async {
    state = state.copyWith(status: SongsStateStatus.loading);
    try {
      final songs = await _homeRepository.getSongs();
      state = state.copyWith(songs: songs, status: SongsStateStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: SongsStateStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> sortSongs(int songSortType, int orderType) async {
    state = state.copyWith(status: SongsStateStatus.loading);
    try {
      await _homeRepository.sortSongs(songSortType, orderType);

      final songs = await _homeRepository.getSongs();
      state = state.copyWith(songs: songs, status: SongsStateStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: SongsStateStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
