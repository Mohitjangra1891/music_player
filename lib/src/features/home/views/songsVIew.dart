import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:my_music_player/src/features/home/views/widgets/songTile.dart';
import 'package:my_music_player/src/utils/extensions.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../res/const.dart';
import '../../../res/images.dart';
import '../../player/controller/player_controller.dart';
import '../../player/repo/player_repository.dart';
import '../controller/songs_controller.dart';



class songsView extends ConsumerStatefulWidget {
  const songsView({super.key});

  @override
  ConsumerState<songsView> createState() => _songsViewState();
}

class _songsViewState extends ConsumerState<songsView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final songsState = ref.watch(songsControllerProvider);
    final player = ref.read(musicPlayerRepositoryProvider);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(songsControllerProvider.notifier).fetchSongs();
        },
        child: songsState.status == SongsStateStatus.loading
            ? Center(child: CircularProgressIndicator())
            : songsState.status == SongsStateStatus.error
                ? Center(child: Text('Error: ${songsState.errorMessage}'))
                : CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 16),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // number of songs
                              Text(
                                '${songsState.songs.length} Songs',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              // sort button
                              IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) => const SortBottomSheet(),
                                  );
                                },
                                icon: const Icon(Icons.swap_vert),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(32),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          Assets.shuffleSvg,
                                          width: 20,
                                          colorFilter: ColorFilter.mode(
                                            Theme.of(context).textTheme.bodyMedium!.color!,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Shuffle',
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      final randomSong = songsState.songs[Random().nextInt(songsState.songs.length)];

                                      final song = player.getMediaItemFromSong(randomSong);
                                      ref.read(playerControllerProvider.notifier).setEnable_ShuffleMode(true);
                                      ref.read(playerControllerProvider.notifier).loadSongs(song, songsState.songs);

                                      // // enable shuffle
                                      // context.read<PlayerBloc>().add(
                                      //   PlayerSetShuffleModeEnabled(true),
                                      // );
                                      //
                                      // // get random song
                                      // final rando  mSong =
                                      // songs[Random().nextInt(songs.length)];
                                      //
                                      // // play random song
                                      // context.read<PlayerBloc>().add(
                                      //   PlayerLoadSongs(
                                      //     songs,
                                      //     sl<MusicPlayer>()
                                      //         .getMediaItemFromSong(randomSong),
                                      //   ),
                                      // );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(32),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          Assets.playSvg,
                                          width: 20,
                                          colorFilter: ColorFilter.mode(
                                            Theme.of(context).textTheme.bodyMedium!.color!,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Play',
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      final song = player.getMediaItemFromSong(songsState.songs[0]);
                                      ref.read(playerControllerProvider.notifier).setEnable_ShuffleMode(false);
                                      ref.read(playerControllerProvider.notifier).loadSongs(song, songsState.songs);
                                      // // disable shuffle
                                      // context.read<PlayerBloc>().add(
                                      //   PlayerSetShuffleModeEnabled(false),
                                      // );
                                      //
                                      // // play first song
                                      // context.read<PlayerBloc>().add(
                                      //   PlayerLoadSongs(
                                      //     songs,
                                      //     sl<MusicPlayer>()
                                      //         .getMediaItemFromSong(songs[0]),
                                      //   ),
                                      // );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 16),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 16),
                      ),
                      songsState.songs.isEmpty
                          ? SliverToBoxAdapter(child: Center(child: Text('No songs found')))
                          : SliverList(
                              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                                final song = songsState.songs[index];

                                return SongListTile(
                                  song: song,
                                  songs: songsState.songs,
                                  player: player,
                                );
                              }, childCount: songsState.songs.length),
                            )
                    ],
                  ),
      ),
    );
  }
}

class SortBottomSheet extends StatefulWidget {
  const SortBottomSheet({super.key});

  @override
  State<SortBottomSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  int currentSortType = Hive.box(HiveBox.boxName).get(
    HiveBox.songSortTypeKey,
    defaultValue: SongSortType.TITLE.index,
  );
  int currentOrderType = Hive.box(HiveBox.boxName).get(
    HiveBox.songOrderTypeKey,
    defaultValue: OrderType.ASC_OR_SMALLER.index,
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Sort by',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          for (final songSortType in SongSortType.values)
            RadioListTile<int>(
              visualDensity: const VisualDensity(
                horizontal: 0,
                vertical: -4,
              ),
              value: songSortType.index,
              groupValue: currentSortType,
              title: Text(
                songSortType.name.capitalize().replaceAll('_', ' '),
              ),
              onChanged: (value) {
                setState(() {
                  currentSortType = value!;
                });
              },
            ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Order by',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          for (final orderType in OrderType.values)
            RadioListTile<int>(
              visualDensity: const VisualDensity(
                horizontal: 0,
                vertical: -4,
              ),
              value: orderType.index,
              groupValue: currentOrderType,
              title: Text(
                orderType.name.capitalize().replaceAll('_', ' '),
              ),
              onChanged: (value) {
                setState(() {
                  currentOrderType = value!;
                });
              },
            ),
          const SizedBox(height: 16),
          // cancel, apply button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Consumer(
                  builder: (context, ref, child) {
                    return Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // context.read<HomeBloc>().add(
                          //   SortSongsEvent(
                          //     currentSortType,
                          //     currentOrderType,
                          //   ),
                          // );
                          ref.read(songsControllerProvider.notifier).sortSongs(currentSortType, currentOrderType);
                        },
                        child: const Text('Apply'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
