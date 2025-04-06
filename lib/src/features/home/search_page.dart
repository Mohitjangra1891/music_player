import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music_player/src/features/home/views/widgets/songTile.dart';
import 'package:my_music_player/src/features/player/repo/player_repository.dart';
import 'package:my_music_player/src/utils/extensions.dart';

import '../../common/repositories/search_repository.dart';
import '../../utils/themes/themes.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    clear();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
   // clear();
    searchController.clear();
    super.dispose();
  }

  Future<void> clear() async {
    await ref.read(searchControllerProvider.notifier).searchSongs(''); // Reset search results
  }

  @override
  Widget build(BuildContext context) {
    final player = ref.watch(musicPlayerRepositoryProvider);
    final searchResults = ref.watch(searchControllerProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Themes.getTheme().secondaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Themes.getTheme().primaryColor,
        title: TextField(
          autofocus: true,
          onChanged: (value) {
            ref.read(searchControllerProvider.notifier).searchSongs(value);
          },
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                searchController.clear();
              });
            },
            icon: const Icon(Icons.clear),
            tooltip: 'Clear',
          ),
        ],
      ),
      body: Ink(
        decoration: BoxDecoration(
          gradient: Themes.getTheme().linearGradient,
        ),
        child: searchResults.when(
          data: (songs) {
            if (songs.isEmpty) {
              return const Center(child: Text("No songs found"));
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Songs',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${songs.length} ${'result'.pluralize(songs.length)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  for (var song in songs)
                    SongListTile(
                      song: song,
                      songs: songs,
                      player: player,
                    ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}
