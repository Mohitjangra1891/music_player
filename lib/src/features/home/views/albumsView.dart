import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music_player/src/features/home/controller/albumController.dart';
import 'package:my_music_player/src/features/home/views/detailsPage/album_page.dart';

import 'package:on_audio_query/on_audio_query.dart';

class AlbumsView extends ConsumerStatefulWidget {
  const AlbumsView({super.key});

  @override
  ConsumerState<AlbumsView> createState() => _AlbumsViewState();
}

class _AlbumsViewState extends ConsumerState<AlbumsView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  //
  // final audioQuery = OnAudioQuery();
  // final albums = <AlbumModel>[];
  // bool isLoading = true;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   context.read<HomeBloc>().add(GetAlbumsEvent());
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final AlbumState = ref.watch(AlbumControllerProvider);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(AlbumControllerProvider.notifier).fetchAlbum();
        },
        child: AlbumState.status == AlbumStateStatus.loading
            ? Center(child: CircularProgressIndicator())
            : AlbumState.status == AlbumStateStatus.error
                ? Center(child: Text('Error: ${AlbumState.errorMessage}'))
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: AlbumState.album.length,
                    itemBuilder: (context, index) {
                      final album = AlbumState.album[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return AlbumPage( album: album,);
                          }));
                        },
                        child: Column(
                          children: [
                            QueryArtworkWidget(
                              id: album.id,
                              type: ArtworkType.ALBUM,
                              artworkHeight: 96,
                              artworkWidth: 96,
                              size: 10000,
                              artworkBorder: BorderRadius.circular(100),
                              nullArtworkWidget: Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.grey.withOpacity(0.1),
                                ),
                                child: const Icon(
                                  Icons.music_note_outlined,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              album.album,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              album.artist ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
