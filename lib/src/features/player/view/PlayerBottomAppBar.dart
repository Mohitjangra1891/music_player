import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:my_music_player/src/features/player/view/playerPage.dart';
import 'package:my_music_player/src/features/player/view/widgets/buttons/play_pause_button.dart';
import 'package:my_music_player/src/features/player/view/widgets/swipeSongCard.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../main.dart';
import '../../../utils/getIt_instances.dart';
import '../../../utils/themes/themes.dart';
import '../../../common/controller/currentSong_controller.dart';
import '../repo/player_repository.dart';

class PlayerBottomAppBar extends ConsumerWidget {
  final PanelController panelController;

  const PlayerBottomAppBar(
    this.panelController, {
    super.key,
  });

//
//   @override
//   ConsumerState<PlayerBottomAppBar> createState() => _PlayerBottomAppBarState();
// }
//
// class _PlayerBottomAppBarState extends ConsumerState<PlayerBottomAppBar> {
  // final player = providerContainer.read(musicPlayerRepositoryProvider);
  // bool isPlaying = false;
  // bool isExpanded = false;

  // final JustAudioPlayer player = JustAudioPlayer();
  // List<SongModel> playlist = [];
  //
  // @override
  // void initState() {
  //   super.initState();
  //   // player.playing.listen((playing) {
  //   //   setState(() {
  //   //     isPlaying = playing;
  //   //   });
  //   // });
  // }

  // Future<void> _getPlaylist() async {
  //   playlist = await player.loadPlaylist();
  //   if (playlist.isEmpty) {
  //     return;
  //   }
  //   // get last played song
  //   SongModel? lastPlayedSong = await sl<RecentsRepository>().fetchLastPlayed();
  //   if (lastPlayedSong != null) {
  //     await player.setSequenceFromPlaylist(playlist, lastPlayedSong);
  //   }
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.read(musicPlayerRepositoryProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        print("tap on collapsed");
        print("tap on collapsed");
        print("tap on collapsed");
        print("tap on collapsed");
        print("tap on collapsed");
        print("tap on collapsed");

        panelController.open();
      },
      child: Container(
          // margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: StreamBuilder<SequenceState?>(
        stream: player.sequenceState,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // if no sequence is loaded, load from hive
            if (player.playlist.isEmpty) {
              // _getPlaylist();
            }
            return const SizedBox();
          }
          print("[PlayerBottomAppBar / StreamBuilder] playing Connection State: ${snapshot.connectionState}");
          print("[PlayerBottomAppBar /StreamBuilder] playing daya: ${snapshot.data}");

          var sequence = snapshot.data;
          MediaItem mediaItem = sequence?.sequence[sequence.currentIndex].tag;

          return SlidingUpPanel(
            controller: panelController,
            minHeight: 80,
            backdropEnabled: true,
            // Allows tap outside to close
            backdropTapClosesPanel: true,
            // Enables closing with back gestures

            // Height of bottom bar when collapsed
            maxHeight: MediaQuery.of(context).size.height,
            // Full-screen height
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            panel: playerScreen(),
            // panel: playerPage(sequence!, mediaItem, player),
            collapsed: _buildCollapsed(sequence!, mediaItem, player),
          );
        },
      )),
    );
  }

  _buildCollapsed(SequenceState sequence, MediaItem mediaItem, JustAudioPlayer player) {
    return Row(
      children: [
        const SizedBox(width: 20),
        // song info with swiping
        Expanded(
          child: SwipeSong(
            sequence: sequence,
            mediaItem: mediaItem,
          ),
        ),
        StreamBuilder<Duration>(
          stream: player.position,
          builder: (context, snapshot) {
            final position = snapshot.data ?? Duration.zero;
            return Text(
              '${position.inMinutes.toString().padLeft(2, '0')}:${(position.inSeconds % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(
                color: Colors.white,
              ),
            );
          },
        ),

        // PlayPauseButton(
        //   width: 20,
        //   player: player,
        // ),

        const SizedBox(width: 20),
      ],
    );
  }
}
