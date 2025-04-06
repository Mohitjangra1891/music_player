import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:my_music_player/src/features/home/views/albumsView.dart';
import 'package:my_music_player/src/features/home/views/artists_view.dart';
import 'package:my_music_player/src/features/home/views/genreView.dart';
import 'package:my_music_player/src/features/home/views/playlists_view.dart';
import 'package:my_music_player/src/features/home/views/songsVIew.dart';
import 'package:my_music_player/src/utils/router.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../main.dart';
import '../player/view/PlayerBottomAppBar.dart';
import '../../res/images.dart';
import '../../utils/themes/themes.dart';

final PanelController panelController = PanelController();

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => homePageState();
}

class homePageState extends State<homePage> with TickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  bool _hasPermission = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  void initState() {
    super.initState();

    checkAndRequestPermissions();
    WidgetsBinding.instance.addObserver(this);

    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future checkAndRequestPermissions({bool retry = false}) async {
    // The param 'retryRequest' is false, by default.
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );

    // Only call update the UI if application has all required permissions.
    _hasPermission ? setState(() {}) : checkAndRequestPermissions(retry: true);
  }

  final tabs = [
    'Songs',
    'Playlists',
    'Artists',
    'Albums',
    'Genres',
  ];

  void handleBackPress() async {
    print("Home  Back button pressed");
    print("Home  Back button pressed");
    print("Home  Back button pressed");
    print("Home  Back button pressed");
    print("Home  Back button pressed");

    if (panelController.isAttached && panelController.isPanelOpen) {
      debugPrint("Closing slide-up panel");
      panelController.close();
      return;
    }

    if (_tabController.index != 0) {
      debugPrint("Switching to first tab");
      _tabController.animateTo(0);
      return;
    }

    debugPrint("Exiting app");
    SystemNavigator.pop();
  }

  void openPanel() async {
    panelController.open();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          handleBackPress();
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        // current song, play/pause button, song progress bar, song queue button
        bottomNavigationBar: PlayerBottomAppBar(panelController),
        extendBody: true,
        backgroundColor: Themes.getTheme().secondaryColor,
        drawer: _buildDrawer(context),
        appBar: _buildAppBar(),
        body: _buildBody(context),
      ),
    );
  }

  Ink _buildBody(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        gradient: Themes.getTheme().linearGradient,
      ),
      child: _hasPermission
          ? Column(
              children: [
                TabBar(
                  dividerColor: Theme.of(context).colorScheme.onPrimary.withOpacity(
                        0.3,
                      ),
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  controller: _tabController,
                  tabs: tabs
                      .map(
                        (e) => Tab(
                          text: e,
                        ),
                      )
                      .toList(),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // SongsView(),
                      // PlaylistsView(),
                      // ArtistsView(),
                      // AlbumsView(),
                      // GenresView(),

                      songsView(),
                      PlaylistsView(),
                      ArtistsView(),
                      AlbumsView(),
                      GenresView()
                    ],
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text('No permission to access library'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () async {
                    // permission request
                    await Permission.storage.request();
                  },
                  child: const Text('Retry'),
                )
              ],
            ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Themes.getTheme().primaryColor,
      // title: const Text('Meloplay'),
      leading: IconButton(
        icon: SvgPicture.asset(
          Assets.menuSvg,
          width: 32,
          height: 32,
          colorFilter: ColorFilter.mode(
            // if theme is dark, invert the color
            Theme.of(context).textTheme.bodyMedium!.color!,
            BlendMode.srcIn,
          ),
        ),
        tooltip: 'Menu',
        onPressed: () => scaffoldKey.currentState?.openDrawer(),
      ),
      // search button
      actions: [
        IconButton(
          onPressed: () {
            context.pushNamed(routeNames.Search);
          },
          icon: const Icon(Icons.search_outlined),
          tooltip: 'Search',
        )
      ],
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(top: 48, bottom: 16),
            decoration: BoxDecoration(
              color: Themes.getTheme().primaryColor,
            ),
            child: Row(
              children: [
                Hero(
                  tag: 'logo',
                  child: Image.asset(
                    Assets.logo,
                    height: 64,
                    width: 64,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  'Meloplay',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey.withOpacity(0.1),
            indent: 16,
            endIndent: 16,
          ),
          // themes
          ListTile(
            leading: const Icon(Icons.color_lens_outlined),
            title: const Text('Themes'),
            onTap: () {
              // Navigator.of(context).pushNamed(AppRouter.themesRoute);
              context.pushNamed(routeNames.themePage);

            },
          ),
          // settings
          ListTile(
            leading: SvgPicture.asset(
              Assets.settingsSvg,
              colorFilter: ColorFilter.mode(
                Theme.of(context).textTheme.bodyMedium!.color!,
                BlendMode.srcIn,
              ),
            ),
            title: const Text('Settings'),
            onTap: () {
              context.pushNamed(routeNames.settings);
              // Navigator.of(context).pushNamed(AppRouter.settingsRoute);
            },
          )
        ],
      ),
    );
  }
}
