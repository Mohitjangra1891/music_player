import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:lottie/lottie.dart';
import 'package:my_music_player/src/features/favourites_and_Recent/controller/favourite_Controller.dart';
import 'package:my_music_player/src/features/home/homePage.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../res/images.dart';
import '../../../player/repo/player_repository.dart';

class SongListTile extends ConsumerWidget {
  final SongModel song;
  final List<SongModel> songs;
  final bool showAlbumArt;
  final JustAudioPlayer player;

  const SongListTile({
    super.key,
    required this.song,
    required this.songs,
    this.showAlbumArt = true,
    required this.player,
  });

  // final player = sl<MusicPlayer>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final playerController = widget.ref.read(playerProvider.notifier);

    return StreamBuilder<SequenceState?>(
      key: ValueKey(song.id),
      stream: player.sequenceState,
      builder: (context, snapshot) {
        MediaItem? currentMediaItem;

        if (snapshot.hasData) {
          var sequence = snapshot.data;
          currentMediaItem = sequence?.sequence[sequence.currentIndex].tag;
        }

        return ListTile(
          contentPadding: EdgeInsets.only(left: 16),
          onTap: () async {
            MediaItem mediaItem = player.getMediaItemFromSong(song);

            // if this is currently playing, navigate to player
            // else load songs
            if (currentMediaItem?.id == mediaItem.id) {
              if (context.mounted) {
                // Navigator.of(context).pushNamed(
                //   AppRouter.playerRoute,
                //   arguments: mediaItem,
                // );
                print("open panel");
                print("open panel");
                print("open panel");
                print("open panel");
                print("open panel");
                homePageState().openPanel();
              }
            } else {
              // playerController.loadSongs(mediaItem, widget.songs);
              player.load(mediaItem, songs);
              ref.invalidate(recentsSongsProvider);

              // context.read<PlayerBloc>().add(
              //   PlayerLoadSongs(widget.songs, mediaItem),
              // );
            }
          },
          leading: _buildLeading(currentMediaItem, player),
          title: _buildTitle(currentMediaItem, context),
          subtitle: _buildSubtitle(context),
          trailing: _buildTrailing(context, ref),
        );
      },
    );
  }

  Widget? _buildLeading(MediaItem? currentMediaItem, JustAudioPlayer player) {
    // if showAlbumArt is false, don't show leading
    if (!showAlbumArt) {
      return null;
    }

    return Stack(
      children: [
        QueryArtworkWidget(
          keepOldArtwork: true,
          id: song.albumId ?? 0,
          type: ArtworkType.ALBUM,
          artworkBorder: BorderRadius.circular(10),
          size: 500,
          nullArtworkWidget: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.withOpacity(0.1),
            ),
            child: const Icon(
              Icons.music_note_outlined,
            ),
          ),
        ),
        if (currentMediaItem != null && currentMediaItem.id == song.id.toString())
          Positioned.fill(
            child: StreamBuilder<bool>(
              stream: player.playing,
              builder: (context, snapshot) {
                final isPlaying = snapshot.data ?? false;

                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primary,
                          BlendMode.srcIn,
                        ),
                        child: Lottie.asset(
                          Assets.playingAnimation,
                          animate: isPlaying,
                          height: 32,
                          width: 32,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }

  Text _buildTitle(MediaItem? currentMediaItem, BuildContext context) {
    return Text(
      song.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: currentMediaItem != null && currentMediaItem.id == song.id.toString() ? Theme.of(context).colorScheme.primary : null,
      ),
    );
  }

  Text _buildSubtitle(BuildContext context) {
    String subtitle = '${song.artist ?? 'Unknown'} | ${song.album ?? 'Unknown'}';
    return Text(
      subtitle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8),
      ),
    );
  }

  IconButton _buildTrailing(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        // add to queue, add to playlist, delete, share
        _buildModalBottomSheet(context, ref);
      },
      icon: const Icon(Icons.more_vert_outlined),
      tooltip: 'More',
    );
  }

  Future<dynamic> _buildModalBottomSheet(BuildContext context, WidgetRef ref) {
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
              // border radius same as bottom sheet
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
              ),
              leading: const Icon(Icons.playlist_add_outlined),
              title: const Text('Add to queue'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.playlist_add_outlined),
            //   title: const Text('Add to playlist'),
            //   onTap: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.delete_outlined),
              title: const Text('Delete'),
              onTap: () {
                // Show a confirmation dialog before deleting the song
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Delete Song'),
                      content: const Text('Are you sure you want to delete this song?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            // Delete the song from the database
                            final file = File(song.data);

                            if (await file.exists()) {
                              debugPrint('Deleting ${song.title}');
                              try {
                                // ask for permission to manage external storage if not granted
                                if (!await Permission.manageExternalStorage.isGranted) {
                                  final status = await Permission.manageExternalStorage.request();

                                  if (status.isGranted) {
                                    debugPrint('Permission granted');
                                  } else {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Permission denied',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                }
                                await file.delete();
                                debugPrint('Deleted ${song.title}');
                              } catch (e) {
                                debugPrint('Failed to delete ${song.title}');
                              }
                            } else {
                              debugPrint('File does not exist ${song.title}');
                            }

                            // TODO: Remove the song from the list
                            if (context.mounted) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text('Share'),
              onTap: () async {
                // await shareSong(context, widget.song.data, widget.song.title);
              },
            ),
          ],
        );
      },
    );
  }
}

