import 'package:flutter/material.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Controls(
            icon: Icons.repeat,
          ),
          Controls(
            icon: Icons.skip_previous,
          ),
          PlayControl(),
          Controls(
            icon: Icons.skip_next,
          ),
          Controls(
            icon: Icons.shuffle,
          ),
        ],
      ),
    );
  }
}

class PlayControl extends StatelessWidget {
  const PlayControl({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        // myAudioModel.audioState == "Playing"
        //     ? myAudioModel.pauseAudio()
        //     : myAudioModel.playAudio();
      },
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.2),
                offset: const Offset(5, 10),
                spreadRadius: 3,
                blurRadius: 10),
            BoxShadow(
                color: theme.colorScheme.background.withOpacity(0.5),
                offset: const Offset(-3, -4),
                spreadRadius: -2,
                blurRadius: 20)
          ],
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: theme.colorScheme.shadow.withOpacity(0.2),
                          offset: const Offset(5, 10),
                          spreadRadius: 3,
                          blurRadius: 10),
                      BoxShadow(
                          color: theme.colorScheme.background.withOpacity(0.5),
                          offset: const Offset(-3, -4),
                          spreadRadius: -2,
                          blurRadius: 20)
                    ]),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle),
                child: Center(
                    child: Icon(
                  'myAudioModel.audioState' == "Playing"
                      ? Icons.pause
                      : Icons.play_arrow,
                  size: 50,
                  color: theme.colorScheme.secondary,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Controls extends StatelessWidget {
  final IconData icon;

  const Controls({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.2),
              offset: const Offset(5, 10),
              spreadRadius: 3,
              blurRadius: 10),
          BoxShadow(
              color: theme.colorScheme.background.withOpacity(0.5),
              offset: const Offset(-3, -4),
              spreadRadius: -2,
              blurRadius: 20)
        ],
      ),
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: theme.colorScheme.shadow.withOpacity(0.2),
                        offset: const Offset(5, 10),
                        spreadRadius: 3,
                        blurRadius: 10),
                    BoxShadow(
                        color: theme.colorScheme.background.withOpacity(0.5),
                        offset: const Offset(-3, -4),
                        spreadRadius: -2,
                        blurRadius: 20)
                  ]),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle),
              child: Center(
                  child: Icon(
                icon,
                size: 30,
                color: theme.colorScheme.onPrimaryContainer,
              )),
            ),
          ),
        ],
      ),
    );
  }
}
