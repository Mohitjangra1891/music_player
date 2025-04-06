


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../repo/homeRepository.dart';

enum ArtistsStateStatus { loading, success, error }

final ArtistsControllerProvider = StateNotifierProvider<ArtistsController, ArtistsState>((ref) {
  final repository = ref.watch(homeRepoProvider);
  return ArtistsController(repository);
});

class ArtistsState {
  final List<ArtistModel> Artists;
  final ArtistsStateStatus status;
  final String? errorMessage;

  ArtistsState({
    this.Artists = const [],
    this.status = ArtistsStateStatus.loading,
    this.errorMessage,
  });

  ArtistsState copyWith({
    List<ArtistModel>? Artists,
    ArtistsStateStatus? status,
    String? errorMessage,
  }) {
    return ArtistsState(
      Artists: Artists ?? this.Artists,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

class ArtistsController extends StateNotifier<ArtistsState> {
  final HomeRepository _homeRepository;

  ArtistsController(this._homeRepository) : super(ArtistsState()) {
    fetchArtists();
  }

  Future<void> fetchArtists() async {
    state = state.copyWith(status: ArtistsStateStatus.loading);
    try {
      final Artists = await _homeRepository.getArtists();
      state = state.copyWith(Artists: Artists, status: ArtistsStateStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: ArtistsStateStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
