import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:my_music_player/src/features/player/view/widgets/seek_bar.dart';
import 'package:my_music_player/src/features/player/view/widgets/spinning_disc_animation.dart';
import 'package:my_music_player/src/features/player/view/playerPage.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../utils/themes/themes.dart';
import '../../repo/player_repository.dart';



class SwipeSong extends ConsumerStatefulWidget {
  const SwipeSong({
    super.key,
    required this.sequence,
    required this.mediaItem,
  });

  final SequenceState? sequence;
  final MediaItem mediaItem;

  @override
  ConsumerState<SwipeSong> createState() => _SwipeSongState();
}

class _SwipeSongState extends ConsumerState<SwipeSong> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: widget.sequence?.currentIndex ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = ref.read(musicPlayerRepositoryProvider);
    return StreamBuilder<int?>(
      stream: player.currentIndex,
      builder: (context, snapshot) {
        if (snapshot.hasData && pageController.hasClients) {
          pageController.jumpToPage(snapshot.data!);
        }
        return PageView.builder(
          itemCount: widget.sequence?.sequence.length ?? 0,
          controller: pageController,
          onPageChanged: (index) {
            if (widget.sequence?.currentIndex != index) {
              player.seek(Duration.zero, index: index);
            }
          },
          itemBuilder: (context, index) {
            MediaItem mediaItem = widget.sequence?.sequence[index].tag;
            return Row(
              children: [
                SpinningDisc(
                  id: int.parse(mediaItem.id),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        mediaItem.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        mediaItem.artist ?? 'Unknown',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Themes.getTheme().colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
              ],
            );
          },
        );
      },
    );
  }
}

