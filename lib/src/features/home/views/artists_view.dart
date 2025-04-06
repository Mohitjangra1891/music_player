import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:on_audio_query/on_audio_query.dart';

import '../controller/artistsController.dart';
import 'detailsPage/artist_page.dart';

class ArtistsView extends ConsumerStatefulWidget {
  const ArtistsView({super.key});

  @override
  ConsumerState<ArtistsView> createState() => _ArtistsViewState();
}

class _ArtistsViewState extends ConsumerState<ArtistsView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  //
  // final audioQuery = OnAudioQuery();
  // final artists = <ArtistModel>[];
  // bool isLoading = true;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   context.read<HomeBloc>().add(GetArtistsEvent());
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ArtistsState = ref.watch(ArtistsControllerProvider);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
          onRefresh: () async {
            await ref.read(ArtistsControllerProvider.notifier).fetchArtists();
          },
          child: ArtistsState.status == ArtistsStateStatus.loading
              ? Center(child: CircularProgressIndicator())
              : ArtistsState.status == ArtistsStateStatus.error
                  ? Center(child: Text('Error: ${ArtistsState.errorMessage}'))
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: ArtistsState.Artists.length,
                      itemBuilder: (context, index) {
                        final artist = ArtistsState.Artists[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return ArtistPage(
                                artist: artist,
                              );
                            }));
                          },
                          child: Column(
                            children: [
                              QueryArtworkWidget(
                                id: artist.id,
                                type: ArtworkType.ARTIST,
                                artworkHeight: 96,
                                artworkWidth: 96,
                                size: 10000,
                                artworkBorder: BorderRadius.circular(25),
                                nullArtworkWidget: Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.grey.withOpacity(0.1),
                                  ),
                                  child: const Icon(
                                    Icons.person_outlined,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                artist.artist,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )),
    );
  }
}
