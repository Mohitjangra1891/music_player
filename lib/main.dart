import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_music_player/src/app.dart';
import 'package:my_music_player/src/features/player/repo/player_repository.dart';
import 'package:my_music_player/src/res/const.dart';
import 'package:my_music_player/src/utils/getIt_instances.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

final providerContainer = ProviderContainer();

Future<void> requestPermissions() async {
  if (await Permission.manageExternalStorage.request().isGranted) {
    print("Manage external storage permission granted");
  } else {
    print("Manage external storage permission denied");
  }
}

Future<void> main() async {
  // initialize flutter engine
  WidgetsFlutterBinding.ensureInitialized();
  init();

  // ask for permission to access media if not granted
  if (!await Permission.mediaLibrary.isGranted) {
    await Permission.mediaLibrary.request();
  }
  requestPermissions();
  // initialize hive
  await Hive.initFlutter();
  await Hive.openBox(HiveBox.boxName);
  await Hive.openBox("playlists");

  // initialize audio service
  // await sl<MusicPlayer>().init();
  await providerContainer.read(musicPlayerRepositoryProvider).init();

  // run app
  runApp(
    ProviderScope(child: const MyApp()),
  );
}
