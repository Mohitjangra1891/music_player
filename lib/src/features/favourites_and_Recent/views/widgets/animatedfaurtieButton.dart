import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:my_music_player/src/common/repositories/song_repository.dart';
import 'package:my_music_player/src/features/favourites_and_Recent/controller/favourite_Controller.dart';

class AnimatedFavoriteButton extends ConsumerStatefulWidget {
  final bool isFavorite;
  final MediaItem mediaItem;

  const AnimatedFavoriteButton({
    super.key,
    required this.isFavorite,
    required this.mediaItem,
  });

  @override
  ConsumerState<AnimatedFavoriteButton> createState() => _AnimatedFavoriteButtonState();
}

class _AnimatedFavoriteButtonState extends ConsumerState<AnimatedFavoriteButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = ref.watch(favoriteProvider(widget.mediaItem.id));

    return GestureDetector(
      onTap: () async {
        _controller.forward();
        // context.read<SongBloc>().add(
        //   ToggleFavorite(widget.mediaItem.id),
        // );
        final songRepo = SongRepository();
        await songRepo.toggleFavorite(widget.mediaItem.id);
        ref.read(favoriteProvider(widget.mediaItem.id).notifier).state =
            songRepo.isFavorite(widget.mediaItem.id);
        ref.invalidate(favoriteSongsProvider);

        // setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16, bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Transform.scale(
          scale: _animation.value,
          child: Icon(
            isFavorite ? Icons.favorite_outlined : Icons.favorite_border_outlined,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
