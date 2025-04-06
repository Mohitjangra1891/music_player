import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';

// Hive Keys
const String playlistsKey = 'playlists';

// 🔹 PROVIDERS 🔹

// Fetch all playlists with song count
final playlistProvider = FutureProvider<Map<String, int>>((ref) async {
  return PlaylistRepository().fetchPlaylists();
});

// Fetch songs inside a specific playlist
final playlistSongsProvider = FutureProvider.family<List<SongModel>, String>((ref, playlistName) async {
  return PlaylistRepository().fetchPlaylistSongs(playlistName);
});

class PlaylistRepository {
  final box = Hive.box('myBox');
  final OnAudioQuery _audioQuery = OnAudioQuery();

  /// Fetch all playlists
  Future<Map<String, int>> fetchPlaylists() async {
    List<String> playlists = box.get(playlistsKey, defaultValue: <String>[]);
    Map<String, int> playlistData = {};

    for (String playlist in playlists) {
      List<String> songIds = box.get(playlist, defaultValue: <String>[]);
      playlistData[playlist] = songIds.length;
    }
    return playlistData;
  }

  /// Add a new playlist
  Future<void> addPlaylist(String playlistName) async {
    List<String> playlists = box.get(playlistsKey, defaultValue: <String>[]);
    if (!playlists.contains(playlistName)) {
      playlists.add(playlistName);
      await box.put(playlistsKey, playlists);
      await box.put(playlistName, <String>[]); // Create an empty playlist
    }
  }
  /// Rename an existing playlist
  Future<void> renamePlaylist(String oldName, String newName) async {
    List<String> playlists = box.get(playlistsKey, defaultValue: <String>[]);

    if (playlists.contains(oldName) && !playlists.contains(newName)) {
      List<String> songIds = box.get(oldName, defaultValue: <String>[]);

      // Remove the old playlist and add the new one
      playlists.remove(oldName);
      playlists.add(newName);
      await box.put(playlistsKey, playlists);

      // Copy songs to the new playlist and delete the old one
      await box.put(newName, songIds);
      await box.delete(oldName);
    }
  }


  /// Delete a playlist
  Future<void> deletePlaylist(String playlistName) async {
    List<String> playlists = box.get(playlistsKey, defaultValue: <String>[]);
    playlists.remove(playlistName);
    await box.put(playlistsKey, playlists);
    await box.delete(playlistName); // Remove song list
  }

  /// Fetch songs in a playlist
  Future<List<SongModel>> fetchPlaylistSongs(String playlistName) async {
    List<String> songIds = box.get(playlistName, defaultValue: <String>[]);
    List<SongModel> allSongs = await _audioQuery.querySongs(uriType: UriType.EXTERNAL);
    return allSongs.where((song) => songIds.contains(song.id.toString())).toList();
  }

  /// Add/Remove a song from a playlist
  Future<void> toggleSongInPlaylist(String playlistName, String songId) async {
    List<String> songIds = box.get(playlistName, defaultValue: <String>[]);

    if (songIds.contains(songId)) {
      songIds.remove(songId);
    } else {
      songIds.add(songId);
    }

    await box.put(playlistName, songIds);
  }
}
