// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive/hive.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:on_audio_query/on_audio_query.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// abstract class PlaylistsState {}
//
// class PlaylistsInitial extends PlaylistsState {}
//
// class PlaylistsLoading extends PlaylistsState {}
//
// class PlaylistsLoaded extends PlaylistsState {
//   final List<PlaylistModel> playlists;
//
//   PlaylistsLoaded(this.playlists);
// }
//
// class PlaylistsSongsLoaded extends PlaylistsState {
//   final List<SongModel> playlistSongs;
//
//   PlaylistsSongsLoaded(this.playlistSongs);
// }
//
// class PlaylistsError extends PlaylistsState {
//   final String message;
//
//   PlaylistsError(this.message);
// }
//
// final playlistsProvider = StateNotifierProvider<PlaylistsNotifier, PlaylistsState>(
//   (ref) => PlaylistsNotifier(),
// );
//
// class PlaylistsNotifier extends StateNotifier<PlaylistsState> {
//   PlaylistsNotifier() : super(PlaylistsInitial()) {
//     queryPlaylists(); // Automatically fetch data when the provider is initialized
//   }
//
//   final OnAudioQuery _audioQuery = OnAudioQuery();
//   List<PlaylistModel> playlists = [];
//   List<SongModel> allsongs = [];
//
//   Future<void> queryPlaylists() async {
//     state = PlaylistsLoading();
//     try {
//       print("getting playlistss");
//       playlists = await _audioQuery.queryPlaylists();
//       for (var playlist in playlists) {
//         List<SongModel> playlistSongs = await _audioQuery.queryAudiosFrom(
//             AudiosFromType.PLAYLIST,
//           playlist.id,
//         );
//
//         print("Playlist: ${playlist.playlist}, Songs: ${playlistSongs.length}");
//         print("Playlist: ${playlist.playlist}, Songs: ${playlistSongs.length}");
//       }
//       state = PlaylistsLoaded(playlists);
//     } catch (e) {
//       state = PlaylistsError(e.toString());
//     }
//   }
//
//   Future<void> createPlaylist(String name) async {
//     state = PlaylistsLoading();
//     try {
//       await _audioQuery.createPlaylist(name);
//       playlists = await _audioQuery.queryPlaylists();
//       state = PlaylistsLoaded(playlists);
//     } catch (e) {
//       state = PlaylistsError(e.toString());
//     }
//   }
//
//   Future<void> queryPlaylistSongs(int playlistId) async {
//     state = PlaylistsLoading();
//     try {
//       List<SongModel> playlistSongs = await _audioQuery.queryAudiosFrom(
//         AudiosFromType.PLAYLIST,
//         playlistId,
//       );
//
//       // Workaround for on_audio_query bug
//       List<SongModel> allSongs = await _audioQuery.querySongs();
//       allSongs.removeWhere(
//         (song) => !playlistSongs.any((element) => element.data == song.data),
//       );
//       allsongs = allSongs;
//       state = PlaylistsSongsLoaded(allSongs);
//     } catch (e) {
//       state = PlaylistsError(e.toString());
//     }
//   }
//
//   Future<void> addToPlaylist(int playlistId, SongModel song) async {
//     state = PlaylistsLoading();
//     try {
//       print("adding to  playlistss");
//       print("adding to  playlistss");
//       print("adding to  playlistss");
//       print("adding to  playlistss");
//
//       await _audioQuery.addToPlaylist(playlistId, song.id);
//       await queryPlaylistSongs(playlistId);
//       await queryPlaylists();
//     } catch (e) {
//       state = PlaylistsError(e.toString());
//     }
//   }
//
//   // Future<void> removeSongFromPlaylist(int playlistId, SongModel song) async {
//   //   state = PlaylistsLoading();
//   //
//   //   try {
//   //     print("removing from  playlistss");
//   //     print("removing from  playlistss");
//   //     print("removingd from  playlistss");
//   //     print("removingd from  playlistss");
//   //
//   //     //
//   //     // bool success = await _audioQuery.removeFromPlaylist(playlistId, song.id);
//   //     // print(success);
//   //     // print(success);
//   //     // print(success);
//   //     // if (success) {
//   //     //   await Future.delayed(const Duration(milliseconds: 500)); // Small delay to ensure database updates
//   //     //   await queryPlaylistSongs(playlistId);
//   //     // } else {
//   //     //   state = PlaylistsError("Failed to remove song from playlist");
//   //     // }
//   //
//   //   } catch (e) {
//   //     print("error");
//   //     print(e);
//   //     print(e);
//   //     print(e);
//   //     print(e);
//   //     print(e);
//   //     state = PlaylistsError(e.toString());
//   //   }
//   // }
//   Future<void> removeSongFromPlaylist(int playlistId, SongModel song) async {
//     try {
//       // First, ensure we have permission
//       // if (!await Permission.storage.isGranted) {
//       //   print("Storage permission not granted.");
//       //   await Permission.storage.request();
//       //   return;
//       // }
//
//       print("Removing song ${song.title} from playlist $playlistId");
//
//       // Remove song from playlist
//       bool success = await _audioQuery.removeFromPlaylist(playlistId, song.id);
//
//       if (success) {
//         print("Song removed successfully!");
//         // await queryPlaylistSongs(playlistId);  // Refresh songs
//
//         List<SongModel> playlistSongs = await _audioQuery.queryAudiosFrom(
//           AudiosFromType.PLAYLIST,
//           playlistId,
//         );
//
//         // Workaround for on_audio_query bug
//         List<SongModel> allSongs = await _audioQuery.querySongs();
//         allSongs.removeWhere(
//               (song) => !playlistSongs.any((element) => element.data == song.data),
//         );
//         print(playlistSongs);
//         print(allSongs);
//         await queryPlaylists();  // Refresh playlists
//       } else {
//         print("Failed to remove song.");
//       }
//     } catch (e) {
//       print("Error removing song: $e");
//     }
//   }
//
//   Future<void> deletePlaylist(int playlistId) async {
//     state = PlaylistsLoading();
//     try {
//       await _audioQuery.removePlaylist(playlistId);
//       playlists = await _audioQuery.queryPlaylists();
//       state = PlaylistsLoaded(playlists);
//     } catch (e) {
//       state = PlaylistsError(e.toString());
//     }
//   }
//
//   Future<void> renamePlaylist(int playlistId, String newName) async {
//     state = PlaylistsLoading();
//     try {
//       await _audioQuery.renamePlaylist(playlistId, newName);
//       playlists = await _audioQuery.queryPlaylists();
//       state = PlaylistsLoaded(playlists);
//     } catch (e) {
//       state = PlaylistsError(e.toString());
//     }
//   }
// }
