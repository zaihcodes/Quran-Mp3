import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_mp3/core/services/theme/app_colors.dart';
import 'package:quran_mp3/src/quran_audio/domain/entities/surah_audio.dart';

class SurahWidget extends StatefulWidget {
  final SurahAudio surah;

  const SurahWidget({Key? key, required this.surah}) : super(key: key);

  @override
  _SurahWidgetState createState() => _SurahWidgetState();
}

class _SurahWidgetState extends State<SurahWidget> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    try {
      final ConcatenatingAudioSource audioSource = ConcatenatingAudioSource(
        children: [
          AudioSource.uri(Uri.parse(widget.surah.link)),
          // Add more audio sources if needed
        ],
      );
      await _audioPlayer.setAudioSource(audioSource);
      // Subscribe to the playerStateStream
      _audioPlayer.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          // Playback finished, seek to the beginning
          _audioPlayer.seek(Duration.zero);
          setState(() {
            _isPlaying = false;
          });
        }
      });
    } catch (e, stackTrace) {
      debugPrint('Error during audio initialization: $e\n$stackTrace');
      // Handle the exception appropriately
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleAudioPlayer() async {
    debugPrint('Toggle audio');
    try {
      setState(() {
        debugPrint('Toggle audio, isPlaying: $_isPlaying');
        _isPlaying = !_isPlaying;
      });
      if (!_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play();
      }
    } catch (e, stackTrace) {
      debugPrint('Error during audio playback: $e\n$stackTrace');
      // Handle the exception appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          margin: const EdgeInsets.fromLTRB(20, 25, 20, 10),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: AppColors.darkPrimaryColor,
                  offset: const Offset(5, 4),
                  spreadRadius: 1,
                  blurRadius: 10),
              const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-3, -4),
                  spreadRadius: -2,
                  blurRadius: 8)
            ],
          ),
          child: Row(
            children: [
              // buildPlayerControl(
              //     isPLaying: _isPlaying, func: _toggleAudioPlayer),
              GestureDetector(
                onTap: _toggleAudioPlayer,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.darkPrimaryColor.withValues(alpha: 0.5),
                          offset: const Offset(5, 10),
                          spreadRadius: 3,
                          blurRadius: 10),
                      const BoxShadow(
                          color: Colors.white,
                          offset: Offset(-3, -4),
                          spreadRadius: -2,
                          blurRadius: 20)
                    ],
                  ),
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: AppColors.darkPrimaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: AppColors.darkPrimaryColor
                                        .withValues(alpha: 0.5),
                                    offset: const Offset(5, 10),
                                    spreadRadius: 3,
                                    blurRadius: 10),
                                const BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(-3, -4),
                                    spreadRadius: -2,
                                    blurRadius: 20)
                              ]),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle),
                          child: Center(
                              child: Icon(
                            // player.state == PlayerState.playing
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 15,
                            color: AppColors.darkPrimaryColor,
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<Duration?>(
                  stream: _audioPlayer.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    final duration = _audioPlayer.duration ?? Duration.zero;
                    return Slider(
                      value: position.inSeconds.toDouble(),
                      max: duration.inSeconds.toDouble(),
                      activeColor: AppColors.darkPrimaryColor,
                      inactiveColor:
                          AppColors.darkPrimaryColor.withValues(alpha: 0.3),
                      onChanged: (value) {
                        final newPosition = Duration(seconds: value.toInt());
                        _audioPlayer.seek(newPosition);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          child: Container(
            // padding: const EdgeInsets.all(12),
            width: 100,
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
            decoration: BoxDecoration(
              color: AppColors.darkPrimaryColor.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'سورة ${widget.surah.name}',
              textAlign: TextAlign.end,
              textDirection: TextDirection.ltr,
              style: TextStyle(color: AppColors.darkPrimaryColor),
            ),
          ),
        ),
      ],
    );
  }
}

Widget buildPlayerControl(
    {required bool isPLaying, required VoidCallback func}) {
  return GestureDetector(
    onTap: func,
    child: Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: AppColors.darkPrimaryColor.withValues(alpha: 0.5),
              offset: const Offset(5, 10),
              spreadRadius: 3,
              blurRadius: 10),
          const BoxShadow(
              color: Colors.white,
              offset: Offset(-3, -4),
              spreadRadius: -2,
              blurRadius: 20)
        ],
      ),
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: AppColors.darkPrimaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.darkPrimaryColor.withValues(alpha: 0.5),
                        offset: const Offset(5, 10),
                        spreadRadius: 3,
                        blurRadius: 10),
                    const BoxShadow(
                        color: Colors.white,
                        offset: Offset(-3, -4),
                        spreadRadius: -2,
                        blurRadius: 20)
                  ]),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: AppColors.primaryColor, shape: BoxShape.circle),
              child: Center(
                  child: Icon(
                // player.state == PlayerState.playing
                isPLaying ? Icons.pause : Icons.play_arrow,
                size: 15,
                color: AppColors.darkPrimaryColor,
              )),
            ),
          ),
        ],
      ),
    ),
  );
}
