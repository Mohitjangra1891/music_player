import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marquee/marquee.dart';
import 'package:my_music_player/src/features/favourites_and_Recent/views/widgets/animatedfaurtieButton.dart';
import 'package:my_music_player/src/features/player/view/widgets/buttons/next_button.dart';
import 'package:my_music_player/src/features/player/view/widgets/buttons/play_pause_button.dart';
import 'package:my_music_player/src/features/player/view/widgets/buttons/previous_button.dart';
import 'package:my_music_player/src/features/player/view/widgets/buttons/repeat_button.dart';
import 'package:my_music_player/src/features/player/view/widgets/buttons/shuffle_button.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../common/repositories/song_repository.dart';
import '../../../utils/themes/themes.dart';
import '../../queue/views/queue_screen.dart';
import '../controller/player_controller.dart';
import 'widgets/seek_bar.dart';
import 'widgets/spinning_disc_animation.dart';
import '../repo/player_repository.dart';
import 'package:flutter/material.dart';

void showQueueBottomSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => DraggableQueue(),
  );
}

class playerScreen extends ConsumerWidget {
  const playerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final player = ref.read(musicPlayerRepositoryProvider);

    return Scaffold(
      body: StreamBuilder<SequenceState?>(
        stream: player.sequenceState,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }
          final sequence = snapshot.data;
          MediaItem? mediaItem = sequence!.sequence[sequence.currentIndex].tag;
          return Stack(
            children: [
              QueryArtworkWidget(
                keepOldArtwork: true,
                artworkHeight: double.infinity,
                id: int.parse(mediaItem!.id),
                type: ArtworkType.AUDIO,
                size: 10000,
                artworkWidth: double.infinity,
                artworkBorder: BorderRadius.circular(0),
                nullArtworkWidget: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: const Icon(
                    Icons.music_note_outlined,
                    size: 100,
                  ),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
              ),
              Column(
                children: [
                  // artwork
                  SizedBox(height: screenHeight * 0.16),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     PopupMenuButton(
                  //       padding: EdgeInsets.all(0),
                  //       position: PopupMenuPosition.under,
                  //       icon: const Icon(
                  //         Icons.more_vert_outlined,
                  //       ),
                  //       itemBuilder: (context) {
                  //         return [
                  //           PopupMenuItem(
                  //             onTap: () {
                  //               showSleepTimer(context);
                  //             },
                  //             child: const Text('Sleep timer'),
                  //           ),
                  //         ];
                  //       },
                  //     ),
                  //   ],
                  // ),

                  Expanded(
                    child: SwipeSongLong(
                      sequence: sequence,
                      mediaItem: mediaItem,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.06),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => showQueueBottomSheet(context, ref),
                        icon: const Icon(
                          Icons.queue_music_outlined,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Spacer(),

                  // seek bar
                  SeekBar(player: player),
                  const SizedBox(height: 16),
                  // shuffle, previous, play/pause, next, repeat
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 25),

                      ShuffleButton(
                        player: player,
                      ),
                      Spacer(),
                      PreviousButton(
                        player: player,
                      ),
                      const SizedBox(width: 8),

                      PlayPauseButton(
                        player: player,
                      ),
                      const SizedBox(width: 8),

                      NextButton(
                        player: player,
                      ),
                      // const SizedBox(width: 8),
                      Spacer(),
                      RepeatButton(
                        player: player,
                      ),
                      const SizedBox(width: 25),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class SwipeSongLong extends ConsumerStatefulWidget {
  const SwipeSongLong({
    super.key,
    required this.sequence,
    required this.mediaItem,
  });

  final SequenceState? sequence;
  final MediaItem mediaItem;

  @override
  ConsumerState<SwipeSongLong> createState() => _SwipeSongState();
}

class _SwipeSongState extends ConsumerState<SwipeSongLong> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: widget.sequence?.currentIndex ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = ref.read(musicPlayerRepositoryProvider);
    return StreamBuilder<int?>(
      stream: player.currentIndex,
      builder: (context, snapshot) {
        if (snapshot.hasData && pageController.hasClients) {
          pageController.jumpToPage(snapshot.data!);
        }
        return PageView.builder(
          itemCount: widget.sequence?.sequence.length ?? 0,
          controller: pageController,
          onPageChanged: (index) {
            if (widget.sequence?.currentIndex != index) {
              player.seek(Duration.zero, index: index);
            }
          },
          itemBuilder: (context, index) {
            MediaItem mediaItem = widget.sequence?.sequence[index].tag;
            return Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      QueryArtworkWidget(
                        artworkClipBehavior: Clip.none,
                        artworkFit: BoxFit.fill,
                        keepOldArtwork: true,
                        id: int.parse(mediaItem.id),
                        type: ArtworkType.AUDIO,
                        size: 10000,
                        artworkWidth: double.infinity,
                        nullArtworkWidget: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            // borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.music_note_outlined,
                            size: MediaQuery.of(context).size.height / 10,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: AnimatedFavoriteButton(
                          isFavorite: SongRepository().isFavorite(mediaItem.id),
                          mediaItem: mediaItem,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // title and artist
                StreamBuilder<SequenceState?>(
                  stream: player.sequenceState,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox.shrink();
                    }
                    final sequence = snapshot.data;

                    MediaItem? mediaItem = sequence!.sequence[sequence.currentIndex].tag;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                            child: AutoSizeText(
                              mediaItem!.title,
                              maxLines: 1,
                              minFontSize: 20,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflowReplacement: Marquee(
                                text: mediaItem.title,
                                blankSpace: 60,
                                startAfter: const Duration(seconds: 3),
                                pauseAfterRound: const Duration(seconds: 0),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            child: AutoSizeText(
                              mediaItem.artist ?? 'Unknown',
                              maxLines: 1,
                              minFontSize: 15,
                              style: TextStyle(fontSize: 15, color: Themes.getTheme().colorScheme.onSurface.withOpacity(0.7)),
                              overflowReplacement: Marquee(
                                text: mediaItem.artist ?? 'Unknown',
                                blankSpace: 100,
                                startAfter: const Duration(seconds: 3),
                                pauseAfterRound: const Duration(seconds: 3),
                                style: TextStyle(fontSize: 15, color: Themes.getTheme().colorScheme.onSurface.withOpacity(0.7)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

void showSleepTimer(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              title: const Text('Off'),
              onTap: () {
                // context.read<PlayerBloc>().add(PlayerSetSleepTimer(null));
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('5 minutes'),
              onTap: () {
                // context.read<PlayerBloc>().add(
                //       PlayerSetSleepTimer(
                //         const Duration(minutes: 5),
                //       ),
                //     );
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('10 minutes'),
              onTap: () {
                // context.read<PlayerBloc>().add(
                //       PlayerSetSleepTimer(
                //         const Duration(minutes: 10),
                //       ),
                //     );
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('15 minutes'),
              onTap: () {
                // context.read<PlayerBloc>().add(
                //       PlayerSetSleepTimer(
                //         const Duration(minutes: 15),
                //       ),
                //     );
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('30 minutes'),
              onTap: () {
                // context.read<PlayerBloc>().add(
                //       PlayerSetSleepTimer(
                //         const Duration(minutes: 30),
                //       ),
                //     );
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('45 minutes'),
              onTap: () {
                // context.read<PlayerBloc>().add(
                //       PlayerSetSleepTimer(
                //         const Duration(minutes: 45),
                //       ),
                //     );
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('1 hour'),
              onTap: () {
                // context.read<PlayerBloc>().add(
                //       PlayerSetSleepTimer(
                //         const Duration(hours: 1),
                //       ),
                //     );
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}
