import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../utils/helpers.dart';
import '../../../../utils/themes/themes.dart';
import '../../../player/repo/player_repository.dart';
import '../../../player/view/PlayerBottomAppBar.dart';
import '../widgets/songTile.dart';

class AlbumPage extends ConsumerStatefulWidget {
  final AlbumModel album;

  const AlbumPage({super.key, required this.album});

  @override
  ConsumerState<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends ConsumerState<AlbumPage> {
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
      AudiosFromType.ALBUM_ID,
      widget.album.id,
    );

    // remove songs less than 10 seconds long (10,000 milliseconds)
    songs.removeWhere((song) => (song.duration ?? 0) < 10000);

    // await songRepository.addSongsToQueue(songs);
    setState(() {
      _songs = songs;
    });
  }


  @override
  Widget build(BuildContext context) {
    final player = ref.read(musicPlayerRepositoryProvider);

    return WillPopScope(
      onWillPop: () async {
        print("album page back buttpo pressed");
        print("album page back buttpo pressed");
        print("album page back buttpo pressed");
        print("album page back buttpo pressed");
        print("album page back buttpo pressed");
        print("album page back buttpo pressed");
        print("album page back buttpo pressed");

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
        body: Ink(
          decoration: BoxDecoration(
            gradient: Themes.getTheme().linearGradient,
          ),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Themes.getTheme().primaryColor,
                expandedHeight: 400,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: LayoutBuilder(
                    builder: (context, constraints) {
                      bool isLarge = constraints.maxHeight > 100;
                      bool isLong = widget.album.album.length > 20;

                      if (isLarge) {
                        return Text(
                          widget.album.album,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        );
                      } else if (!isLong) {
                        return Text(
                          widget.album.album,
                          style: TextStyle(
                            color: calculateTextColor(
                              Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        );
                      } else {
                        return Marquee(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          text: widget.album.album,
                          style: TextStyle(
                            color: calculateTextColor(
                              Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                          blankSpace: 100,
                          pauseAfterRound: const Duration(seconds: 1),
                        );
                      }
                    },
                  ),
                  background: QueryArtworkWidget(
                    artworkBlendMode: BlendMode.darken,
                    artworkColor: Colors.black.withOpacity(0.5),
                    id: widget.album.id,
                    type: ArtworkType.ALBUM,
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
                ),
              ),

              // number of songs
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Text(
                    '${_songs.length} ${_songs.length > 1 ? "songs" : "song"}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),

              // song list
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return SongListTile(
                      song: _songs[index],
                      showAlbumArt: false,
                      songs: _songs,
                      player: player,
                    );
                  },
                  childCount: _songs.length,
                ),
              ),

              // margin for bottom app bar
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
