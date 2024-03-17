import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_mp3/core/services/theme/app_colors.dart';
import 'package:quran_mp3/src/quran_audio/domain/entities/surah_audio.dart';

class AudioPlayerWidget extends StatefulWidget {
  final SurahAudio surah;

  const AudioPlayerWidget({Key? key, required this.surah}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
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
        children: [AudioSource.uri(Uri.parse(widget.surah.link))],
      );
      await _audioPlayer.setAudioSource(audioSource);

      _audioPlayer.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          _audioPlayer.pause();
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
    try {
      setState(() {
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
    final theme = Theme.of(context);
    return Stack(
      children: [
        _buildAudioPlayerContainer(theme: theme),
        Positioned(
          right: 0,
          child: _buildSurahInfoContainer(theme: theme),
        ),
      ],
    );
  }

  Widget _buildAudioPlayerContainer({required ThemeData theme}) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.fromLTRB(20, 25, 20, 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.2),
            offset: const Offset(5, 4),
            spreadRadius: 1,
            blurRadius: 10,
          ),
          BoxShadow(
            color: theme.colorScheme.background.withOpacity(0.3),
            offset: const Offset(-3, -4),
            spreadRadius: -2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          _buildPlayerControl(theme: theme),
          Expanded(
            child: StreamBuilder<Duration?>(
              stream: _audioPlayer.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final duration = _audioPlayer.duration ?? Duration.zero;
                return _buildSlider(position, duration, theme);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerControl({required ThemeData theme}) {
    return GestureDetector(
      onTap: _toggleAudioPlayer,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.2),
              offset: const Offset(3, 8),
              spreadRadius: 3,
              blurRadius: 12,
            ),
            BoxShadow(
              color: theme.colorScheme.background.withOpacity(0.3),
              offset: const Offset(-3, -4),
              spreadRadius: -2,
              blurRadius: 20,
            ),
          ],
        ),
        child: _buildPlayerControlStack(theme: theme),
      ),
    );
  }

  Widget _buildPlayerControlStack({required ThemeData theme}) {
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withOpacity(0.2),
                  offset: const Offset(3, 8),
                  spreadRadius: 2,
                  blurRadius: 10,
                ),
                BoxShadow(
                  color: theme.colorScheme.background.withOpacity(0.3),
                  offset: const Offset(-3, -4),
                  spreadRadius: -2,
                  blurRadius: 20,
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                size: 15,
                color: theme.colorScheme.secondary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlider(Duration position, Duration duration, ThemeData theme) {
    return Slider(
      value: position.inSeconds.toDouble(),
      max: duration.inSeconds.toDouble(),
      activeColor: theme.colorScheme.secondary,
      inactiveColor: theme.colorScheme.secondary.withOpacity(0.3),
      onChanged: (value) {
        final newPosition = Duration(seconds: value.toInt());
        _audioPlayer.seek(newPosition);
      },
    );
  }

  Widget _buildSurahInfoContainer({required ThemeData theme}) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'سورة ${widget.surah.name}',
        textAlign: TextAlign.end,
        textDirection: TextDirection.ltr,
        style: TextStyle(color: theme.colorScheme.primaryContainer),
      ),
    );
  }
}
