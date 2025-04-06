import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_music_player/main.dart';

import '../../../../../res/images.dart';
import '../../../repo/player_repository.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    super.key,
    this.width = 40,
    this.color = Colors.white,
    required this.player,
  });

  final MusicPlayer player;
  final double width;
  final Color color;

  @override
  Widget build(BuildContext) {
    return StreamBuilder<bool>(
      stream: player.playing,
      builder: (context, snapshot) {
        final playing = snapshot.data ?? false;
        return IconButton(
          onPressed: () {
            if (playing) {
              player.pause();
              // context.read<PlayerBloc>().add(PlayerPause());
            } else {
              player.play();
              // context.read<PlayerBloc>().add(PlayerPlay());
            }
          },
          icon: playing
              ? Icon(
                  Icons.pause_circle_outline_outlined,
                  color: Colors.white,
                  size: width,
                )
              : Icon(
                  Icons.play_circle_outlined,
                  color: Colors.white,
                  size: width,
                ),
          tooltip: 'Play/Pause',
        );
      },
    );
  }
}
