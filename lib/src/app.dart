import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music_player/src/utils/router.dart';
import 'package:my_music_player/src/utils/themes/app_theme_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateProvider<ThemeData>((ref) {
  return AppThemeData.getTheme(); // Initial theme from Hive
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context ,WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Meloplay',
      theme: theme,
      routerConfig: router,
    );
  }
}
