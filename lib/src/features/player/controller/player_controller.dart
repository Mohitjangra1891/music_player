import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../repo/player_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_music_player/src/common/repositories/song_repository.dart';

sealed class PlayerState {
  const PlayerState();
}

class PlayerInitial extends PlayerState {}

class PlayerLoading extends PlayerState {}

class PlayerSongsLoaded extends PlayerState {}

class PlayerPlaying extends PlayerState {}

class PlayerPaused extends PlayerState {}

class PlayerStopped extends PlayerState {}

class PlayerSeeked extends PlayerState {
  final Duration position;

  const PlayerSeeked(this.position);
}

class PlayerShuffle extends PlayerState {}

class PlayerSetSpeed extends PlayerState {
  final double speed;

  PlayerSetSpeed(this.speed);
}

class PlayerSetLoopMode extends PlayerState {
  final LoopMode loopMode;

  PlayerSetLoopMode(this.loopMode);
}

class PlayerSetShuffleModeEnabled extends PlayerState {
  final bool shuffleModeEnabled;

  PlayerSetShuffleModeEnabled(this.shuffleModeEnabled);
}

class PlayerError extends PlayerState {
  final String message;

  const PlayerError(this.message);
}

final playerControllerProvider = StateNotifierProvider<PlayerController, PlayerState>((ref) {
  final pro = ref.watch(musicPlayerRepositoryProvider);
  return PlayerController(repository: pro);
});

class PlayerController extends StateNotifier<PlayerState> {
  final JustAudioPlayer repository;

  PlayerController({required this.repository}) : super(PlayerInitial());

  Future<void> loadSongs(MediaItem mediaItem, List<SongModel> playlist) async {
    try {
      state = PlayerLoading();
      await repository.load(mediaItem, playlist);
      state = PlayerSongsLoaded();
    } catch (e) {
      state = PlayerError(e.toString());
    }
  }

  Future<void> play() async {
    try {
      await repository.play();
      state = PlayerPlaying();
    } catch (e) {
      state = PlayerError(e.toString());
    }
  }

  Future<void> pause() async {
    try {
      await repository.pause();
      state = PlayerPaused();
    } catch (e) {
      state = PlayerError(e.toString());
    }
  }

  Future<void> stop() async {
    try {
      await repository.stop();
      state = PlayerStopped();
    } catch (e) {
      state = PlayerError(e.toString());
    }
  }

  Future<void> seek(Duration position, {int? index}) async {
    try {
      await repository.seek(position, index: index);
      state = PlayerSeeked(position);
    } catch (e) {
      state = PlayerError(e.toString());
    }
  }

  Future<void> setVolume(double volume) async {
    try {
      await repository.setVolume(volume);
      // Add an optional state to reflect volume changes if necessary
    } catch (e) {
      state = PlayerError(e.toString());
    }
  }

  Future<void> setSpeed(double speed) async {
    try {
      await repository.setSpeed(speed);
      // Add an optional state to reflect speed changes if necessary
    } catch (e) {
      state = PlayerError(e.toString());
    }
  }

  Future<void> setEnable_ShuffleMode(bool shuffleOn) async {
    try {
      await repository.setShuffleModeEnabled(shuffleOn);
      state = PlayerSetShuffleModeEnabled(shuffleOn);
    } catch (e) {
      state = PlayerError(e.toString());
    }
  }

  Future<void> setLoopHoleMode(LoopMode loopMode) async {
    try {
      await repository.setLoopMode(loopMode);
      state = PlayerSetLoopMode(loopMode);
    } catch (e) {
      state = PlayerError(e.toString());
    }
  }
}
