import 'package:flutter/material.dart';

import '../../repo/player_repository.dart';

class SeekBar extends StatelessWidget {
  const SeekBar({
    super.key,
    required this.player,
  });

  final MusicPlayer player;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: player.position,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        return StreamBuilder<Duration?>(
          stream: player.duration,
          builder: (context, snapshot) {
            final duration = snapshot.data ?? Duration.zero;
            return Column(
              children: [
                // position and duration text
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '     ${position.inMinutes.toString().padLeft(2, '0')}:${(position.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}     ',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 5.0, // Increases the track thickness
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0), // Enlarges the thumb
                  ),
                  child: Slider(
                    // allowedInteraction: SliderInteraction.tapAndSlide,
                    inactiveColor: Colors.grey.shade600,
                    activeColor: Theme.of(context).colorScheme.primary,
                    value: position > duration
                        ? duration.inMilliseconds.toDouble()
                        : position.inMilliseconds.toDouble(),
                    min: 0,
                    max: duration.inMilliseconds.toDouble(),
                    onChanged: (value) {
                      // context.read<PlayerBloc>().add(
                      //       PlayerSeek(
                      //         Duration(milliseconds: value.toInt()),
                      //       ),
                      //     );
                      player.seek(Duration(milliseconds: value.toInt()));
                    },
                  ),
                ),


              ],
            );
          },
        );
      },
    );
  }
}
