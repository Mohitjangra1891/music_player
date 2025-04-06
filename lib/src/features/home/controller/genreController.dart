
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../repo/homeRepository.dart';

enum GenreStateStatus { loading, success, error }

final GenreControllerProvider = StateNotifierProvider<GenreController, GenreState>((ref) {
  final repository = ref.watch(homeRepoProvider);
  return GenreController(repository);
});

class GenreState {
  final List<GenreModel> Genre;
  final GenreStateStatus status;
  final String? errorMessage;

  GenreState({
    this.Genre = const [],
    this.status = GenreStateStatus.loading,
    this.errorMessage,
  });

  GenreState copyWith({
    List<GenreModel>? Genre,
    GenreStateStatus? status,
    String? errorMessage,
  }) {
    return GenreState(
      Genre: Genre ?? this.Genre,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

class GenreController extends StateNotifier<GenreState> {
  final HomeRepository _homeRepository;

  GenreController(this._homeRepository) : super(GenreState()) {
    fetchGenre();
  }

  Future<void> fetchGenre() async {
    state = state.copyWith(status: GenreStateStatus.loading);
    try {
      final Genre = await _homeRepository.getGenres();
      state = state.copyWith(Genre: Genre, status: GenreStateStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: GenreStateStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
