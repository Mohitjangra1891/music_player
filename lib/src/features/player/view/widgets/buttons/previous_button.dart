import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../res/images.dart';
import '../../../repo/player_repository.dart';

class PreviousButton extends StatelessWidget {
  const PreviousButton({
    super.key,
    required this.player,
  });

  final MusicPlayer player;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        // context.read<PlayerBloc>().add(PlayerPrevious());
        player.seekToPrevious();
      },
      icon:  Icon(
        Icons.skip_previous_sharp,
        color: Colors.white,
        size: 30,
      ),
      tooltip: 'Previous',
    );
  }
}
