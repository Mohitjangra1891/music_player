import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../res/images.dart';
import '../../../repo/player_repository.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key,  required this.player,
  });

  final MusicPlayer player;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        // context.read<PlayerBloc>().add(PlayerNext());
        player.seekToNext();
      },
      icon: Icon(
        Icons.skip_next_sharp,
        color: Colors.white,
        size: 30 ,
      ),
      // icon: SvgPicture.asset(Assets.nextSvg, width: 35),
      tooltip: 'Next',
    );
  }
}
