import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_music_player/src/features/favourites_and_Recent/views/recents_page.dart';
import 'package:my_music_player/src/features/home/homePage.dart';
import 'package:my_music_player/src/features/home/views/songsVIew.dart';

import '../common/views/splash.dart';
import '../features/drawer/scan_page.dart';
import '../features/drawer/settings_page.dart';
import '../features/drawer/themes_page.dart';
import '../features/favourites_and_Recent/views/favourite_page.dart';
import '../features/home/search_page.dart';

class routeNames {
  static String splash = '/splash';
  static String home = '/home';
  static String Search = '/Search';
  static String songspage = '/songs';
  static String favourites = '/favourites';
  static String recentSongs = '/recentSongs';
  static String settings = '/settings';
  static String scanPage = '/scanPage';
  static String themePage = '/themes';
}

final GoRouter router = GoRouter(
  initialLocation: routeNames.splash,
  routes: [
    GoRoute(
      name: routeNames.splash,
      path: routeNames.splash,
      builder: (BuildContext context, GoRouterState state) {
        return SplashPage();
      },
    ),
    GoRoute(
      name: routeNames.home,
      path: routeNames.home,
      builder: (BuildContext context, GoRouterState state) {
        return homePage();
      },
    ),
    GoRoute(
      name: routeNames.Search,
      path: routeNames.Search,
      builder: (BuildContext context, GoRouterState state) {
        return SearchPage();
      },
    ),
    GoRoute(
      name: routeNames.songspage,
      path: routeNames.songspage,
      builder: (BuildContext context, GoRouterState state) {
        return songsView();
      },
    ),
    GoRoute(
      name: routeNames.favourites,
      path: routeNames.favourites,
      builder: (BuildContext context, GoRouterState state) {
        return favourite_page();
      },
    ),
    GoRoute(
      name: routeNames.recentSongs,
      path: routeNames.recentSongs,
      builder: (BuildContext context, GoRouterState state) {
        return recents_page();
      },
    ),
    GoRoute(
      name: routeNames.themePage,
      path: routeNames.themePage,
      builder: (BuildContext context, GoRouterState state) {
        return ThemesPage();
      },
    ),
    GoRoute(
      name: routeNames.settings,
      path: routeNames.settings,
      builder: (BuildContext context, GoRouterState state) {
        return SettingsPage();
      },
    ),
    GoRoute(
      name: routeNames.scanPage,
      path: routeNames.scanPage,
      builder: (BuildContext context, GoRouterState state) {
        return ScanPage();
      },
    ),
  ],
);
