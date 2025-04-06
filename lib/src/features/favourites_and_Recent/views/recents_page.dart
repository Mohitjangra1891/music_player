import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music_player/src/features/favourites_and_Recent/controller/favourite_Controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../utils/themes/themes.dart';
import '../../player/repo/player_repository.dart';
import '../../player/view/PlayerBottomAppBar.dart';
import '../../home/controller/songs_controller.dart';
import '../../home/views/widgets/songTile.dart';

class recents_page extends ConsumerStatefulWidget {
  const recents_page({super.key});

  @override
  ConsumerState<recents_page> createState() => _recents_pageState();
}

class _recents_pageState extends ConsumerState<recents_page> {
  // List<SongModel> _songs = [];
  final PanelController panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    final player = ref.read(musicPlayerRepositoryProvider);
    final recentSongs = ref.watch(recentsSongsProvider);

    return WillPopScope(
      onWillPop: () async {
        print("recents page back button  pressed");
        print("recents page back button  pressed");
        print("recents page back button  pressed");
        print("recents page back button  pressed");

        if (panelController.isAttached && panelController.isPanelOpen) {
          debugPrint("Closing slide-up panel");
          panelController.close();
          return false;
        }

        return true;
      },
      child: Scaffold(
        // current song, play/pause button, song progress bar, song queue button
        bottomNavigationBar: PlayerBottomAppBar(panelController),
        extendBody: true,
        appBar: AppBar(
          title: Text("Recents"),
          backgroundColor: Themes.getTheme().primaryColor,
        ),
        body: Ink(
          decoration: BoxDecoration(
            gradient: Themes.getTheme().linearGradient,
          ),
          child: recentSongs.when(
            data: (songs) {
              if (songs.isEmpty) {
                return const Center(child: Text('No songs found'));
              }
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 100),
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  return SongListTile(
                    song: songs[index],
                    songs: songs,
                    player: player,
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
          ),
        ),
      ),
    );
  }
}
