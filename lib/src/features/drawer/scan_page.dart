import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:my_music_player/src/utils/extensions.dart';

import '../../res/const.dart';
import '../../res/images.dart';
import '../../utils/themes/themes.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  // in seconds
  int durationValue = Hive.box(HiveBox.boxName).get(
    HiveBox.minSongDurationKey,
    defaultValue: 0,
  );
  List<int> durationGroupValue = [0, 15, 30, 60];

  // in KB
  int sizeValue = Hive.box(HiveBox.boxName).get(
    HiveBox.minSongSizeKey,
    defaultValue: 0,
  );
  List<int> sizeGroupValue = [0, 50, 100, 200, 500];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.getTheme().secondaryColor,
      appBar: AppBar(
        backgroundColor: Themes.getTheme().primaryColor,
        elevation: 0,
        title: const Text(
          'Scan',
        ),
      ),
      body: Ink(
        decoration: BoxDecoration(
          gradient: Themes.getTheme().linearGradient,
        ),
        child: ListView(
          children: [
            // scanning animation
            Lottie.asset(
              Assets.scanningAnimation,
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 16),
            // ignore duration less than value
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Ignore duration less than:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            for (int i = 0; i < durationGroupValue.length; i++)
              RadioListTile(
                title: Text(
                  '${durationGroupValue[i]} ${'second'.pluralize(durationGroupValue[i])}',
                ),
                value: durationGroupValue[i],
                groupValue: durationValue,
                onChanged: (value) async {
                  durationValue = value as int;
                  await Hive.box(HiveBox.boxName).put(
                    HiveBox.minSongDurationKey,
                    durationValue,
                  );
                  setState(() {});
                },
              ),
            const SizedBox(height: 16),
            // ignore size less than value
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Ignore size less than:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            for (int i = 0; i < sizeGroupValue.length; i++)
              RadioListTile(
                title: Text(
                  '${sizeGroupValue[i]} ${'KB'.pluralize(sizeGroupValue[i])}',
                ),
                value: sizeGroupValue[i],
                groupValue: sizeValue,
                onChanged: (value) async {
                  sizeValue = value as int;
                  await Hive.box(HiveBox.boxName).put(
                    HiveBox.minSongSizeKey,
                    sizeValue,
                  );
                  setState(() {});
                },
              ),
          ],
        ),
      ),
    );
  }
}
