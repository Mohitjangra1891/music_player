import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../res/images.dart';
import '../../../../../utils/getIt_instances.dart';
import '../../../controller/player_controller.dart';
import '../../../repo/player_repository.dart';

class ShuffleButton extends ConsumerWidget {
  const ShuffleButton({
    super.key,
    required this.player,
  });

  final MusicPlayer player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<bool>(
      stream: player.shuffleModeEnabled,
      builder: (context, snapshot) {
        return IconButton(
          onPressed: () async {
            // player.setShuffleModeEnabled(snapshot.data ?? false);
            ref.read(playerControllerProvider.notifier).setEnable_ShuffleMode(
                  !(snapshot.data ?? false),
                );
            // ref.read(playerControllerProvider.notifier).Enable_ShuffleMode();

            // context.read<PlayerBloc>().add(
            //       PlayerSetShuffleModeEnabled(
            //         !(snapshot.data ?? false),
            //       ),
            //     );
          },
          icon: snapshot.data == false
              ? SvgPicture.asset(
            Assets.shuffleSvg,
            colorFilter: ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          )
              : SvgPicture.asset(
                  Assets.shuffleSvg,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
          tooltip: 'Shuffle',
        );
      },
    );
  }
}
