import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../player/repo/player_repository.dart';

class DraggableQueue extends ConsumerStatefulWidget {
  const DraggableQueue({Key? key}) : super(key: key);

  @override
  _DraggableQueueState createState() => _DraggableQueueState();
}

class _DraggableQueueState extends ConsumerState<DraggableQueue> {
  // late List queue;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   queue = List.from(widget.playerController.queue);
  // }

  @override
  Widget build(BuildContext context) {
    final player = ref.read(musicPlayerRepositoryProvider);
    // final queue = ref.watch(queueProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: player.playlist.length,
        itemBuilder: (context, index) {
          final song = player.playlist[index];
          return ListTile(
            contentPadding: EdgeInsets.only(left: 16),
            onTap: () async {},
            title: Text(
              song.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(Icons.drag_handle),
          );
        },
      ),
      // padding: EdgeInsets.all(16),
      // child: Column(
      //   children: [
      //     Text("Queue", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      //     Expanded(
      //       child: ReorderableListView(
      //         onReorder: (oldIndex, newIndex) {
      //           if (newIndex > oldIndex) newIndex--;
      //
      //           // widget.playerController.updateQueue(queue);
      //         },
      //         children: [
      //           for (int index = 0; index < player.playlist.length; index++)
      //             StreamBuilder<SequenceState?>(
      //               stream: player.sequenceState,
      //               builder: (context, snapshot) {
      //                 MediaItem? currentMediaItem;
      //
      //                 if (snapshot.hasData) {
      //                   var sequence = snapshot.data;
      //                   currentMediaItem = sequence?.sequence[sequence.currentIndex].tag;
      //                 }
      //
      //                 return ListTile(
      //                   contentPadding: EdgeInsets.only(left: 16),
      //                   onTap: () async {
      //                     MediaItem mediaItem = player.getMediaItemFromSong(widget.song);
      //
      //                     // if this is currently playing, navigate to player
      //                     // else load songs
      //                     if (currentMediaItem?.id == mediaItem.id) {
      //                       // if (context.mounted) {
      //                       //   // Navigator.of(context).pushNamed(
      //                       //   //   AppRouter.playerRoute,
      //                       //   //   arguments: mediaItem,
      //                       //   // );
      //                       //   print("open panel");
      //                       //   print("open panel");
      //                       //   print("open panel");
      //                       //   print("open panel");
      //                       //   print("open panel");
      //                       //   homePageState().openPanel();
      //                       // }
      //                     } else {
      //                       // playerController.loadSongs(mediaItem, widget.songs);
      //                       player.load(mediaItem, player.playlist);
      //                       // context.read<PlayerBloc>().add(
      //                       //   PlayerLoadSongs(widget.songs, mediaItem),
      //                       // );
      //                     }
      //                   },
      //                   title: _buildTitle(currentMediaItem, context),
      //                   trailing: Icon(Icons.drag_handle),
      //                 );
      //               },
      //             ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

// Text _buildTitle(MediaItem? currentMediaItem, BuildContext context) {
//   return Text(
//     song.title,
//     maxLines: 1,
//     overflow: TextOverflow.ellipsis,
//     style: TextStyle(
//       fontWeight: FontWeight.bold,
//       color: currentMediaItem != null && currentMediaItem.id == song.id.toString() ? Theme.of(context).colorScheme.primary : null,
//     ),
//   );
// }
}

