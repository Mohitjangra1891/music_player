// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:on_audio_query/on_audio_query.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
//
// import '../../../utils/themes/themes.dart';
// import '../../player/repo/player_repository.dart';
// import '../../player/view/PlayerBottomAppBar.dart';
// import '../controller/playList_Controller.dart';
// import '../../home/controller/songs_controller.dart';
// import '../../home/views/widgets/songTile.dart';
// import 'addSongtoPlaylist_page.dart';
//
// class PlaylistDetailsPage extends ConsumerStatefulWidget {
//   final PlaylistModel playlist;
//
//   const PlaylistDetailsPage({super.key, required this.playlist});
//
//   @override
//   ConsumerState<PlaylistDetailsPage> createState() => _PlaylistDetailsPageState();
// }
//
// class _PlaylistDetailsPageState extends ConsumerState<PlaylistDetailsPage> {
//   List<SongModel> _songs = [];
//   final PanelController panelController = PanelController();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadPlaylists_Songs();
//     });
//   }
//
//   void _loadPlaylists_Songs() {
//     final playlistState = ref.read(playlistsProvider);
//     if (playlistState is PlaylistsSongsLoaded) {
//       setState(() {
//         _songs = playlistState.playlistSongs; // Store locally
//       });
//     } else {
//       ref.read(playlistsProvider.notifier).queryPlaylistSongs(widget.playlist.id);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final player = ref.read(musicPlayerRepositoryProvider);
//     final playlistState = ref.watch(playlistsProvider);
//     // if (playlistState is PlaylistsLoading) return CircularProgressIndicator();
//     if (playlistState is PlaylistsSongsLoaded) {
//       print("playlist song updated");
//       print("playlist song updated");
//       print("playlist song updated");
//       print("playlist song updated");
//       _songs = playlistState.playlistSongs; // Update local cache
//     }
//
//     return Scaffold(
//       // current song, play/pause button, song progress bar, song queue button
//       bottomNavigationBar: PlayerBottomAppBar(panelController),
//       extendBody: true,
//       appBar: AppBar(
//         title: Text(widget.playlist.playlist),
//         backgroundColor: Themes.getTheme().primaryColor,
//       ),
//       body: Ink(
//           decoration: BoxDecoration(
//             gradient: Themes.getTheme().linearGradient,
//           ),
//           child: _songs.isNotEmpty
//                   ? ListView.builder(
//                       itemCount: _songs.length,
//                       itemBuilder: (context, index) {
//                         // setState(() {
//                         //   _songs = playlistState.playlistSongs;
//                         // });
//                         final song = _songs[index];
//                         return SongListTile(
//                           song: song,
//                           songs: _songs,
//                           player: player,
//                         );
//                       },
//                     )
//                   : Center(child: Text("No Playlists"))),
//
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigator.of(context).pushNamed(
//           //   AppRouter.addSongToPlaylistRoute,
//           //   arguments: {
//           //     'playlist': widget.playlist,
//           //     'songs': _songs,
//           //   },
//           // );
//           Navigator.push(context, MaterialPageRoute(builder: (context) {
//             return AddSongToPlaylist(playlist: widget.playlist, songs: _songs);
//           }));
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../../utils/themes/themes.dart';
import '../../favourites_and_Recent/views/widgets/animatedfaurtieButton.dart';
import '../../home/views/widgets/songTile.dart';
import '../../player/repo/player_repository.dart';
import '../../player/view/PlayerBottomAppBar.dart';
import '../repo/playlist_repository.dart';
import 'addSongtoPlaylist_page.dart';

class PlaylistDetailScreen extends ConsumerWidget {
  final String playlistName;

  const PlaylistDetailScreen({super.key, required this.playlistName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.read(musicPlayerRepositoryProvider);

    final playlistSongs = ref.watch(playlistSongsProvider(playlistName));
    final PanelController panelController = PanelController();

    return Scaffold(
      bottomNavigationBar: PlayerBottomAppBar(panelController),
      extendBody: true,
      appBar: AppBar(
        title: Text(playlistName),
        backgroundColor: Themes.getTheme().primaryColor,
      ),
      body: Ink(
        decoration: BoxDecoration(
          gradient: Themes.getTheme().linearGradient,
        ),
        child: playlistSongs.when(
          data: (songs) => songs.isEmpty
              ? Stack(
                  children: [
                    const Center(child: Text('No songs in this playlist')),
                    Positioned(
                      bottom: 85,
                      right: 15,
                      child: Material(
                        color: Themes.getTheme().colorScheme.primary,
                        elevation: 5, // Adjust elevation here
                        shape: CircleBorder(), // Optional: Circular shape
                        child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddSongToPlaylist(
                                    songs: songs,
                                    playlist: playlistName,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              CupertinoIcons.plus,
                              color: Colors.white,
                              size: 24,
                            )),
                      ),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    ListView.builder(
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        // return ListTile(
                        //   title: Text(song.title),
                        //   subtitle: Text(song.artist ?? "Unknown Artist"),
                        //   trailing: IconButton(
                        //     icon: const Icon(Icons.delete, color: Colors.red),
                        //     onPressed: () async {
                        //       await PlaylistRepository().toggleSongInPlaylist(playlistName, song.id.toString());
                        //       ref.invalidate(playlistSongsProvider(playlistName));
                        //       ref.invalidate(playlistProvider);
                        //     },
                        //   ),
                        // );
                        return SongListTile(
                          song: song,
                          songs: songs,
                          player: player,
                        );
                      },
                    ),
                    Positioned(
                      bottom: 85,
                      right: 15,
                      child: Material(
                        color: Themes.getTheme().colorScheme.primary,
                        elevation: 5, // Adjust elevation here
                        shape: CircleBorder(), // Optional: Circular shape
                        child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddSongToPlaylist(
                                    songs: songs,
                                    playlist: playlistName,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              CupertinoIcons.plus,
                              color: Colors.white,
                              size: 24,
                            )),
                      ),
                    ),
                  ],
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}
