import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../utils/themes/themes.dart';
import '../../player/repo/player_repository.dart';
import '../../player/view/PlayerBottomAppBar.dart';
import '../controller/playList_Controller.dart';
import '../../home/controller/songs_controller.dart';
import '../../home/views/widgets/songTile.dart';
import '../repo/playlist_repository.dart';

class AddSongToPlaylist extends ConsumerStatefulWidget {
  const AddSongToPlaylist({
    super.key,
    required this.playlist,
    required this.songs,
  });

  final String playlist;
  final List<SongModel> songs;

  @override
  ConsumerState<AddSongToPlaylist> createState() => _AddSongToPlaylistState();
}

class _AddSongToPlaylistState extends ConsumerState<AddSongToPlaylist> {
  // final List<SongModel> _songs = [];

  @override
  Widget build(BuildContext context) {
    final songsState = ref.watch(songsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add songs to playlist'),
        backgroundColor: Themes.getTheme().primaryColor,
      ),
      body: Ink(
        decoration: BoxDecoration(
          gradient: Themes.getTheme().linearGradient,
        ),
        child: songsState.status == SongsStateStatus.loading
            ? Center(child: CircularProgressIndicator())
            : songsState.status == SongsStateStatus.error
                ? Center(child: Text('Error: ${songsState.errorMessage}'))
                : ListView.builder(
                    itemCount: songsState.songs.length,
                    itemBuilder: (context, index) {
                      final song = songsState.songs[index];
                      return CheckboxListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                        title: Text(
                          song.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          song.artist ?? 'Unknown',
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                        value: widget.songs.map((e) => e.data).contains(song.data),
                        onChanged: (value) async {
                          if (value!) {
                            widget.songs.add(song);
                            // ref.read(playlistsProvider.notifier).addToPlaylist(
                            //   widget.playlist.id,
                            //   song,
                            // );
                            await PlaylistRepository().toggleSongInPlaylist(widget.playlist, song.id.toString());
                            ref.invalidate(playlistProvider);
                          } else {
                            // ref.read(playlistsProvider.notifier).removeSongFromPlaylist(
                            //   widget.playlist.id,
                            //   song,
                            // );
                            widget.songs.remove(song);
                            await PlaylistRepository().toggleSongInPlaylist(widget.playlist, song.id.toString());
                            ref.invalidate(playlistProvider);

                            // TODO: Remove song from playlist
                            // widget.songs.remove(song);
                            // context.read<PlaylistsCubit>().removeFromPlaylist(
                            //       widget.playlist.id,
                            //       song.id,
                            //     );
                          }
                          setState(() {});
                        },
                      );
                    },
                  ),
      ),
    );
  }
}
