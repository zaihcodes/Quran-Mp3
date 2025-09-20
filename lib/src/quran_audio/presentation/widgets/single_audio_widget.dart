import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_mp3/src/quran_audio/domain/entities/surah_audio.dart';
import 'package:quran_mp3/core/error/exceptions.dart';

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
  bool _hasError = false;
  String? _errorMessage;
  bool _isLoading = false;
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
      setState(() {
        _isLoading = true;
        _hasError = false;
        _errorMessage = null;
      });

      // Validate URL
      if (widget.surah.link.isEmpty) {
        throw const AudioPlaybackException(
          'رابط الصوت غير متوفر',
          AudioPlaybackErrorType.invalidUrl,
          code: 'EMPTY_URL',
        );
      }

      Uri? uri;
      try {
        uri = Uri.parse(widget.surah.link);
      } catch (e) {
        throw AudioPlaybackException(
          'رابط الصوت غير صحيح',
          AudioPlaybackErrorType.invalidUrl,
          audioUrl: widget.surah.link,
          code: 'INVALID_URL',
          originalError: e,
        );
      }

      final ConcatenatingAudioSource audioSource = ConcatenatingAudioSource(
        children: [AudioSource.uri(uri)],
      );

      await _audioPlayer.setAudioSource(audioSource);

      _audioPlayer.playerStateStream.listen(
        (playerState) {
          if (playerState.processingState == ProcessingState.completed) {
            _audioPlayer.pause();
            _audioPlayer.seek(Duration.zero);
            setState(() {
              _isPlaying = false;
            });
          }
        },
        onError: (error) {
          _handleAudioError('خطأ في حالة المشغل', error);
        },
      );

      setState(() {
        _isLoading = false;
      });
    } on AudioPlaybackException catch (e) {
      _handleAudioError(e.message, e);
    } on PlayerException catch (e) {
      _handleAudioError('فشل في تحميل الصوت: ${e.message}', e);
    } catch (e) {
      _handleAudioError('حدث خطأ غير متوقع أثناء تحميل الصوت', e);
    }
  }

  void _handleAudioError(String message, dynamic error) {
    setState(() {
      _hasError = true;
      _errorMessage = message;
      _isPlaying = false;
      _isLoading = false;
    });
    debugPrint('Audio Error: $message\nOriginal Error: $error');
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggleAudioPlayer() async {
    if (_hasError) {
      // Retry initialization if there was an error
      await _initAudioPlayer();
      return;
    }

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
    } on PlayerException catch (e) {
      _handleAudioError('فشل في تشغيل الصوت: ${e.message}', e);
    } catch (e) {
      _handleAudioError('حدث خطأ أثناء تشغيل الصوت', e);
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
              color: theme.colorScheme.shadow.withValues(alpha: 0.05),
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
                                color: _hasError
                                    ? theme.colorScheme.error
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _hasError
                                  ? _errorMessage ?? 'حدث خطأ في الصوت'
                                  : _isLoading
                                      ? 'جاري التحميل...'
                                      : 'سورة ${widget.surah.name}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: _hasError
                                    ? theme.colorScheme.error
                                    : theme.colorScheme.onSurface.withValues(alpha: 0.7),
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
        color: _hasError
            ? theme.colorScheme.errorContainer
            : theme.colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: _isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.primary,
                ),
              )
            : Icon(
                _hasError
                    ? Icons.refresh_rounded
                    : _isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                color: _hasError
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
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
        inactiveTrackColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        thumbColor: theme.colorScheme.primary,
        overlayColor: theme.colorScheme.primary.withValues(alpha: 0.1),
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
