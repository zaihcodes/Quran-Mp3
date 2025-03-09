import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_mp3/core/services/theme/app_colors.dart';
import 'package:quran_mp3/src/quran_audio/domain/entities/surah_audio.dart';
import 'package:quran_mp3/src/quran_audio/presentation/bloc/player/player_bloc.dart';

class AudioPlayerWidget extends StatefulWidget {
  final SurahAudio surah;

  const AudioPlayerWidget({Key? key, required this.surah}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget>
    with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

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
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggleAudioPlayer() async {
    try {
      setState(() {
        _isPlaying = !_isPlaying;
      });

      if (!_isPlaying) {
        _controller.reverse();
        await _audioPlayer.pause();
      } else {
        _controller.forward();
        await _audioPlayer.play();
      }
    } catch (e, stackTrace) {
      debugPrint('Error during audio playback: $e\n$stackTrace');
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.05),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _toggleAudioPlayer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildPlayButton(theme),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.surah.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'سورة ${widget.surah.name}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      StreamBuilder<Duration?>(
                        stream: _audioPlayer.positionStream,
                        builder: (context, snapshot) {
                          final position = snapshot.data ?? Duration.zero;
                          return Text(
                            _formatDuration(position),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  StreamBuilder<Duration?>(
                    stream: _audioPlayer.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      final duration = _audioPlayer.duration ?? Duration.zero;
                      return _buildProgressBar(position, duration, theme);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayButton(ThemeData theme) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: theme.colorScheme.primary,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildProgressBar(
      Duration position, Duration duration, ThemeData theme) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 6,
        ),
        overlayShape: const RoundSliderOverlayShape(
          overlayRadius: 14,
        ),
        activeTrackColor: theme.colorScheme.primary,
        inactiveTrackColor: theme.colorScheme.primary.withOpacity(0.1),
        thumbColor: theme.colorScheme.primary,
        overlayColor: theme.colorScheme.primary.withOpacity(0.1),
      ),
      child: Slider(
        min: 0.0,
        max: duration.inMilliseconds.toDouble(),
        value: position.inMilliseconds.toDouble(),
        onChanged: (value) {
          final newPosition = Duration(milliseconds: value.round());
          _audioPlayer.seek(newPosition);
        },
      ),
    );
  }
}
