
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';

// Define a model for the song (optional, if needed)
class Song {
  final int id;
  final String title;
  final String album;
  final String artist;
  final String? genre;
  final int duration;
  final String? artUri;
  final bool playable;

  Song({
    required this.id,
    required this.title,
    required this.album,
    required this.artist,
    this.genre,
    required this.duration,
    this.artUri,
    required this.playable,
  });

  // Convert from a map if needed
  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id'],
      title: map['title'],
      album: map['album'],
      artist: map['artist'],
      genre: map['genre'],
      duration: map['duration'],
      artUri: map['artUri'],
      playable: map['playable'],
    );
  }
}

// Controller to manage the song state
class SongController extends StateNotifier<MediaItem?> {
  SongController() : super(null);

  void setSong(MediaItem song) {
    state = song; // Replace the existing song
  }

  void clearSong() {
    state = null;
  }
}
final songControllerProvider =
StateNotifierProvider<SongController, MediaItem?>((ref) => SongController());
