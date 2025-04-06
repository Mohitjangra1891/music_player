import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_music_player/src/features/home/homePage.dart';
import 'package:my_music_player/src/utils/router.dart';

import '../../res/images.dart';
import '../../utils/themes/themes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // after 1 seconds, navigate to home page

    Future.delayed(
      const Duration(seconds: 1),
      () {
        if (mounted) {
          context.goNamed(routeNames.home);
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          //   return homePage();
          // }));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Ink(
        decoration: BoxDecoration(
          gradient: Themes.getTheme().linearGradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              Assets.logo,
              width: 200,
              height: 200,
            ),
            const Text(
              'Meloplay',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
