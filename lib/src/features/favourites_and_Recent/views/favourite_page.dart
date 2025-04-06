import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../utils/themes/themes.dart';
import '../../player/repo/player_repository.dart';
import '../../player/view/PlayerBottomAppBar.dart';
import '../../home/controller/songs_controller.dart';
import '../../home/views/widgets/songTile.dart';
import '../controller/favourite_Controller.dart';

class favourite_page extends ConsumerStatefulWidget {
  const favourite_page({super.key});

  @override
  ConsumerState<favourite_page> createState() => _favourite_pageState();
}

class _favourite_pageState extends ConsumerState<favourite_page> {
  // List<SongModel> _songs = [];
  final PanelController panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    final player = ref.read(musicPlayerRepositoryProvider);
    final favoriteSongs = ref.watch(favoriteSongsProvider);

    return WillPopScope(
      onWillPop: () async {
        print("Favorites page back button  pressed");
        print("Favorites page back button  pressed");
        print("Favorites page back button  pressed");
        print("Favorites page back button  pressed");

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
          title: Text("Favourites"),
          backgroundColor: Themes.getTheme().primaryColor,
        ),
        body: Ink(
          decoration: BoxDecoration(
            gradient: Themes.getTheme().linearGradient,
          ),
          child: favoriteSongs.when(
            data: (songs) {
              if (songs.isEmpty) {
                return const Center(child: Text('No favorite songs'));
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
