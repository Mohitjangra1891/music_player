import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:my_music_player/src/features/home/controller/genreController.dart';
import 'package:my_music_player/src/features/home/views/widgets/songTile.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../res/images.dart';
import '../../player/controller/player_controller.dart';
import '../controller/songs_controller.dart';
import 'detailsPage/genreDetailPage.dart';

class GenresView extends ConsumerStatefulWidget {
  const GenresView({super.key});

  @override
  ConsumerState<GenresView> createState() => _GenresViewState();
}

class _GenresViewState extends ConsumerState<GenresView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

// final audioQuery = sl<OnAudioQuery>();
// final genres = <GenreModel>[];
// bool isLoading = true;

// @override
// void initState() {
//   super.initState();
//   context.read<HomeBloc>().add(GetGenresEvent());
// }

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final genreState = ref.watch(GenreControllerProvider);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(GenreControllerProvider.notifier).fetchGenre();
        },
        child: genreState.status == GenreStateStatus.loading
            ? Center(child: CircularProgressIndicator())
            : genreState.status == GenreStateStatus.error
                ? Center(child: Text('Error: ${genreState.errorMessage}'))
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: genreState.Genre.length,
                    itemBuilder: (context, index) {
                      final genre = genreState.Genre[index];

                      return ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return GenrePage( genre: genre,);
                          }));
                        },
                        leading: QueryArtworkWidget(
                          id: genre.id,
                          type: ArtworkType.GENRE,
                          artworkBorder: BorderRadius.circular(10),
                          size: 10000,
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
                        title: Text(
                          genre.genre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${genre.numOfSongs} song${genre.numOfSongs == 1 ? '' : 's'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
