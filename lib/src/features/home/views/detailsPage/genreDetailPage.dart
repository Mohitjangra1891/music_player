import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:my_music_player/src/features/home/controller/genreController.dart';
import 'package:my_music_player/src/features/home/views/widgets/songTile.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../../main.dart';
import '../../../../utils/themes/themes.dart';
import '../../../player/repo/player_repository.dart';
import '../../../player/view/PlayerBottomAppBar.dart';

class GenrePage extends ConsumerStatefulWidget {
  final GenreModel genre;

  const GenrePage({super.key, required this.genre});

  @override
  ConsumerState<GenrePage> createState() => _GenrePageState();
}

class _GenrePageState extends ConsumerState<GenrePage> {
  late List<SongModel> _songs;
  final PanelController panelController = PanelController();

  @override
  void initState() {
    super.initState();
    _songs = [];
    _getSongs();
  }

  Future<void> _getSongs() async {
    final OnAudioQuery audioQuery = OnAudioQuery();
    final List<SongModel> songs = await audioQuery.queryAudiosFrom(
      AudiosFromType.GENRE_ID,
      widget.genre.id,
    );

    // remove songs less than 10 seconds long (10,000 milliseconds)
    songs.removeWhere((song) => (song.duration ?? 0) < 10000);

    setState(() {
      _songs = songs;
    });
  }

  @override
  Widget build(BuildContext context) {
    final player = ref.read(musicPlayerRepositoryProvider);

    return WillPopScope(
      onWillPop: () async {

        print("gener page back buttpo pressed");
        print("gener page back buttpo pressed");
        print("gener page back buttpo pressed");
        print("gener page back buttpo pressed");
        print("gener page back buttpo pressed");
        print("gener page back buttpo pressed");
        print("gener page back buttpo pressed");
        print("gener page back buttpo pressed");
        print("gener page back buttpo pressed");


        if (panelController.isAttached && panelController.isPanelOpen) {
          debugPrint("Closing slide-up panel");
          panelController.close();
          return false;
        }

        return true;
      },

      child: Scaffold(
        // current song, play/pause button, song progress bar, song queue button
        bottomNavigationBar:  PlayerBottomAppBar(panelController),
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Themes.getTheme().primaryColor,
          title: Text(
            widget.genre.genre,
          ),
        ),
        body: Ink(
          decoration: BoxDecoration(
            gradient: Themes.getTheme().linearGradient,
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: _songs.length,
                  itemBuilder: (context, index) {
                    final SongModel song = _songs[index];

                    return SongListTile(
                      song: song,
                      songs: _songs,
player: player,                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
