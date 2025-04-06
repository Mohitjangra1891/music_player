import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../../res/images.dart';
import '../../../../../utils/getIt_instances.dart';
import '../../../controller/player_controller.dart';
import '../../../repo/player_repository.dart';

class RepeatButton extends ConsumerWidget {
  const RepeatButton({
    super.key,
    required this.player,
  });

  final MusicPlayer player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<LoopMode>(
      stream: player.loopMode,
      builder: (context, snapshot) {
        return IconButton(
          onPressed: () {
            if (snapshot.data == LoopMode.off) {
              // context.read<PlayerBloc>().add(
              //       PlayerSetLoopMode(LoopMode.all),
              //     );
              ref.read(playerControllerProvider.notifier).setLoopHoleMode(LoopMode.all);
            } else if (snapshot.data == LoopMode.all) {
              // context.read<PlayerBloc>().add(
              //       PlayerSetLoopMode(LoopMode.one),
              //     );
              ref.read(playerControllerProvider.notifier).setLoopHoleMode(LoopMode.one);
            } else {
              // context.read<PlayerBloc>().add(
              //       PlayerSetLoopMode(LoopMode.off),
              //     );
              ref.read(playerControllerProvider.notifier).setLoopHoleMode(LoopMode.off);
            }
          },
          icon: snapshot.data == LoopMode.off
              ? const Icon(
                  Icons.repeat_outlined,
                  color: Colors.grey,
                )
              : snapshot.data == LoopMode.all
                  ? Icon(
                      Icons.repeat_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : Icon(
                      Icons.repeat_one_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
          iconSize: 30,
          tooltip: 'Repeat',
        );
      },
    );
  }
}
