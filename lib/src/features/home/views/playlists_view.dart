import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:my_music_player/src/features/playlist/view/widgets/playlistCard.dart';
import 'package:my_music_player/src/utils/extensions.dart';
import 'package:my_music_player/src/utils/router.dart';

import 'package:on_audio_query/on_audio_query.dart';

import '../../../res/images.dart';
import '../../player/repo/player_repository.dart';
import '../../playlist/repo/playlist_repository.dart';
import '../controller/albumController.dart';
import '../../playlist/controller/playList_Controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../playlist/view/playlist_page.dart';

class PlaylistsView extends ConsumerStatefulWidget {
  const PlaylistsView({super.key});

  @override
  ConsumerState<PlaylistsView> createState() => _PlaylistsViewState();
}

class _PlaylistsViewState extends ConsumerState<PlaylistsView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<PlaylistModel> _localPlaylists = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _loadPlaylists();
    });
  }

  //
  // void _loadPlaylists() {
  //   final playlistState = ref.read(playlistsProvider);
  //   if (playlistState is PlaylistsLoaded) {
  //     setState(() {
  //       _localPlaylists = playlistState.playlists; // Store locally
  //     });
  //   } else {
  //     ref.read(playlistsProvider.notifier).queryPlaylists();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // final playlistState = ref.watch(playlistsProvider);
    final playlists = ref.watch(playlistProvider);

    final cards = [
      const SizedBox(width: 16),
      PlaylistCard(
        image: Assets.heart,
        label: 'Favorites',
        icon: Icons.favorite_border_outlined,
        color: Colors.red,
        onTap: () {
          context.pushNamed(routeNames.favourites);
        },
      ),
      const SizedBox(width: 16),
      PlaylistCard(
        image: Assets.earphones,
        label: 'Recents',
        icon: Icons.history_outlined,
        color: Colors.yellow,
        onTap: () {
          context.pushNamed(routeNames.recentSongs);
        },
      ),
      const SizedBox(width: 16),
    ];
    // if (playlistState is PlaylistsLoaded) {
    //   print("playlist view updated");
    //   print("playlist view updated");
    //   print("playlist view updated");
    //   print("playlist view updated");
    //   print("playlist view updated");
    //
    //   _localPlaylists = playlistState.playlists; // Update local cache
    // }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () async {
          // await ref.read(playlistsProvider.notifier).queryPlaylists();
          // _loadPlaylists();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [...cards],
              ),
              const SizedBox(height: 20),

              // add playlist
              ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => _createPlaylistDialog(context, false),
                  );
                },
                leading: const Icon(Icons.add),
                title: const Text('Add playlist'),
              ),

              // // playlistState is PlaylistsLoading
              // //     ? Center(child: CircularProgressIndicator())
              // //     :
              // //
              // _localPlaylists.isNotEmpty
              //     ? ListView.builder(
              //         shrinkWrap: true,
              //         physics: const NeverScrollableScrollPhysics(),
              //         itemCount: _localPlaylists.length,
              //         padding: const EdgeInsets.only(bottom: 100),
              //         itemBuilder: (context, index) {
              //           final playlist = _localPlaylists[index];
              //           return ListTile(
              //             onTap: () {
              //               Navigator.push(context, MaterialPageRoute(builder: (context) {
              //                 return PlaylistDetailsPage(playlist: playlist);
              //               }));
              //               ref.read(playlistsProvider.notifier).queryPlaylists(); // Refresh playlists
              //             },
              //             onLongPress: () {
              //               // delete playlist
              //               showDialog(
              //                 context: context,
              //                 builder: (context) => _buildDeletePlaylistDialog(
              //                   playlist,
              //                   context,
              //                 ),
              //               );
              //             },
              //             leading: const Icon(Icons.music_note),
              //             title: Text(playlist.playlist),
              //             subtitle: Text(
              //               '${playlist.numOfSongs} ${'song'.pluralize(playlist.numOfSongs)}',
              //             ),
              //             trailing: const Icon(Icons.chevron_right),
              //           );
              //         },
              //       )
              //     : Center(child: Text("No Playlists")),
              //
              //
              //

              playlists.when(
                data: (data) => data.isEmpty
                    ? const Center(child: Text('No Playlists'))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        padding: const EdgeInsets.only(bottom: 100),
                        itemBuilder: (context, index) {
                          final playlistName = data.keys.elementAt(index);
                          final songCount = data.values.elementAt(index);
                          return ListTile(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return PlaylistDetailScreen(playlistName: playlistName);
                              }));
                              // ref.read(playlistsProvider.notifier).queryPlaylists(); // Refresh playlists
                            },
                            onLongPress: () {
                              _buildModalBottomSheet(context, ref, playlistName);
                              // delete playlist
                            },
                            leading: const Icon(Icons.music_note),
                            title: Text(playlistName),
                            subtitle: Text(
                              '${songCount} ${'song'.pluralize(songCount)}',
                            ),
                            trailing: const Icon(Icons.chevron_right),
                          );
                        },
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(child: Text('Error: $error')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _buildModalBottomSheet(BuildContext context, WidgetRef ref, String playlistName) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.drive_file_rename_outline),
              title: const Text('Rename playlist'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => _createPlaylistDialog(context, true,oldName:  playlistName),
                );
                // Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outlined),
              title: const Text('Delete Playlist'),
              onTap: () {
                // Show a confirmation dialog before deleting the song
                showDialog(
                  context: context,
                  builder: (context) => _buildDeletePlaylistDialog(
                    playlistName,
                    context,
                  ),
                );
                // Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  AlertDialog _createPlaylistDialog(BuildContext context, bool isRenaming, {String? oldName}) {
    final TextEditingController _controller = TextEditingController();

    return AlertDialog(
      title: Text(isRenaming ? "Rename Playlist" : 'Add playlist'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Playlist name',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            // Step 1: Gather playlist information
            String playlistName = _controller.text.trim();
            if (playlistName.isEmpty) {
              // return, show an error message if the name is empty
              Fluttertoast.showToast(msg: 'Playlist name cannot be empty');
              return;
            }

            // Step 2: Add playlist
            // ref.read(playlistsProvider.notifier).createPlaylist(playlistName);
            //
            if (isRenaming) {
              await PlaylistRepository().renamePlaylist(oldName!, playlistName);
              ref.invalidate(playlistProvider);
            } else {
              await PlaylistRepository().addPlaylist(playlistName);
              ref.invalidate(playlistProvider);
            }

            // Step 3: Close dialog
            Navigator.of(context).pop();
          },
          child: Text(isRenaming ? "Rename" : 'Add'),
        ),
      ],
    );
  }

  AlertDialog _buildDeletePlaylistDialog(
    String playlist,
    BuildContext context,
  ) {
    return AlertDialog(
      title: const Text('Delete playlist'),
      content: Text('Are you sure you want to delete "${playlist}"?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            // ref.read(playlistsProvider.notifier).deletePlaylist(playlist.id);
            await PlaylistRepository().deletePlaylist(playlist);
            ref.invalidate(playlistProvider);

            Navigator.of(context).pop();
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
