import 'package:flutter/material.dart';
import 'package:quran_mp3/src/quran_audio/presentation/widgets/album_art.dart';
import 'package:quran_mp3/src/quran_audio/presentation/widgets/custom_app_bar.dart';

import '../widgets/play_controls.dart';

class SurahPlayScreen extends StatelessWidget {
  const SurahPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const CustomNavigationBar(),
          Container(
            margin: const EdgeInsets.only(left: 40),
            height: height / 2.5,
            child: ListView.builder(
              itemBuilder: (context, index) {
                // return null;

                return const AlbumArt();
              },
              itemCount: 1,
              scrollDirection: Axis.horizontal,
            ),
          ),
          Text(
            'Gidget',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.secondary),
          ),
          Text(
            'The Free Nationals',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.secondary),
          ),
          Column(
            children: [
              SliderTheme(
                data: const SliderThemeData(
                    trackHeight: 5,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5)),
                child: Slider(
                  value: 0,
                  activeColor: theme.colorScheme.secondary,
                  inactiveColor: theme.colorScheme.secondary.withOpacity(0.3),
                  onChanged: (value) {
                    // myAudioModel
                    //     .seekAudio(Duration(milliseconds: value.toInt()));
                  },
                  min: 0,
                  max: 0,
                ),
              ),
            ],
          ),
          const PlayerControls(),
          const SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }
}
