

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../repo/homeRepository.dart';

enum AlbumStateStatus { loading, success, error }

final AlbumControllerProvider = StateNotifierProvider<AlbumController, AlbumState>((ref) {
  final repository = ref.watch(homeRepoProvider);
  return AlbumController(repository);
});

class AlbumState {
  final List<AlbumModel> album;
  final AlbumStateStatus status;
  final String? errorMessage;

  AlbumState({
    this.album = const [],
    this.status = AlbumStateStatus.loading,
    this.errorMessage,
  });

  AlbumState copyWith({
    List<AlbumModel>? album,
    AlbumStateStatus? status,
    String? errorMessage,
  }) {
    return AlbumState(
      album: album ?? this.album,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

class AlbumController extends StateNotifier<AlbumState> {
  final HomeRepository _homeRepository;

  AlbumController(this._homeRepository) : super(AlbumState()) {
    fetchAlbum();
  }

  Future<void> fetchAlbum() async {
    state = state.copyWith(status: AlbumStateStatus.loading);
    try {
      final Album = await _homeRepository.getAlbums();
      state = state.copyWith(album: Album, status: AlbumStateStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: AlbumStateStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
