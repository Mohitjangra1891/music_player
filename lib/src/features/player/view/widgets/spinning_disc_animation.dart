import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../../utils/getIt_instances.dart';
import '../../repo/player_repository.dart';

class SpinningDisc extends ConsumerStatefulWidget {
  final int id;

  const SpinningDisc({super.key, required this.id});

  @override
  ConsumerState<SpinningDisc> createState() => _SpinningDiscState();
}

class _SpinningDiscState extends ConsumerState<SpinningDisc>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = ref.read(musicPlayerRepositoryProvider);

    return StreamBuilder<bool>(
      stream: player.playing,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        // if not playing, don't stop the animation
        if (!snapshot.data!) {
          _controller.stop();
        } else {
          _controller.repeat();
        }
        return AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Transform.rotate(
              angle: _controller.value * 2 * pi,
              child: child,
            );
          },
          child: QueryArtworkWidget(
            keepOldArtwork: true,
            id: widget.id,
            type: ArtworkType.AUDIO,
            size: 500,
            quality: 100,
            artworkBorder: BorderRadius.circular(100),
            nullArtworkWidget: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(Icons.music_note_outlined),
            ),
          ),
        );
      },
    );
  }
}
