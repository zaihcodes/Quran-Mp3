// import 'package:audioplayers/audioplayers.dart';

import 'package:just_audio/just_audio.dart';
import 'package:quran_mp3/core/error/exceptions.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String? _currentUrl;

  /// Get the current audio player instance
  AudioPlayer get audioPlayer => _audioPlayer;

  /// Get the current playing URL
  String? get currentUrl => _currentUrl;

  /// Load and play audio from URL
  Future<void> play(String url) async {
    try {
      if (url.isEmpty) {
        throw const AudioPlaybackException(
          'URL الصوت فارغ',
          AudioPlaybackErrorType.invalidUrl,
          code: 'EMPTY_URL',
        );
      }

      // Validate URL format
      Uri? uri;
      try {
        uri = Uri.parse(url);
      } catch (e) {
        throw AudioPlaybackException(
          'تنسيق URL غير صحيح',
          AudioPlaybackErrorType.invalidUrl,
          audioUrl: url,
          code: 'INVALID_URL_FORMAT',
          originalError: e,
        );
      }

      if (!uri.hasScheme || (!uri.scheme.startsWith('http') && !uri.scheme.startsWith('file'))) {
        throw AudioPlaybackException(
          'URL غير مدعوم. يجب أن يبدأ بـ http أو https أو file',
          AudioPlaybackErrorType.invalidUrl,
          audioUrl: url,
          code: 'UNSUPPORTED_URL_SCHEME',
        );
      }

      // Set URL and load audio
      await _audioPlayer.setUrl(url);
      _currentUrl = url;

      // Start playing
      await _audioPlayer.play();
      isPlaying = true;
    } on AudioPlaybackException {
      rethrow; // Re-throw our custom exceptions
    } on PlayerException catch (e) {
      throw AudioPlaybackException(
        'خطأ في مشغل الصوت: ${e.message}',
        _mapPlayerExceptionType(e),
        audioUrl: url,
        code: 'PLAYER_EXCEPTION',
        originalError: e,
      );
    } on PlayerInterruptedException catch (e) {
      throw AudioPlaybackException(
        'تم مقاطعة تشغيل الصوت: ${e.message}',
        AudioPlaybackErrorType.deviceError,
        audioUrl: url,
        code: 'PLAYER_INTERRUPTED',
        originalError: e,
      );
    } catch (e) {
      throw AudioPlaybackException(
        'فشل في تشغيل الصوت: ${e.toString()}',
        AudioPlaybackErrorType.unknown,
        audioUrl: url,
        code: 'PLAY_ERROR',
        originalError: e,
      );
    }
  }

  /// Pause audio playback
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
      isPlaying = false;
    } on PlayerException catch (e) {
      throw AudioPlaybackException(
        'فشل في إيقاف الصوت مؤقتاً: ${e.message}',
        AudioPlaybackErrorType.deviceError,
        audioUrl: _currentUrl,
        code: 'PAUSE_ERROR',
        originalError: e,
      );
    } catch (e) {
      throw AudioPlaybackException(
        'فشل في إيقاف الصوت مؤقتاً: ${e.toString()}',
        AudioPlaybackErrorType.unknown,
        audioUrl: _currentUrl,
        code: 'PAUSE_ERROR',
        originalError: e,
      );
    }
  }

  /// Resume audio playback
  Future<void> resume() async {
    try {
      await _audioPlayer.play();
      isPlaying = true;
    } on PlayerException catch (e) {
      throw AudioPlaybackException(
        'فشل في استكمال تشغيل الصوت: ${e.message}',
        AudioPlaybackErrorType.deviceError,
        audioUrl: _currentUrl,
        code: 'RESUME_ERROR',
        originalError: e,
      );
    } catch (e) {
      throw AudioPlaybackException(
        'فشل في استكمال تشغيل الصوت: ${e.toString()}',
        AudioPlaybackErrorType.unknown,
        audioUrl: _currentUrl,
        code: 'RESUME_ERROR',
        originalError: e,
      );
    }
  }

  /// Stop audio playback
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      isPlaying = false;
      _currentUrl = null;
    } on PlayerException catch (e) {
      throw AudioPlaybackException(
        'فشل في إيقاف الصوت: ${e.message}',
        AudioPlaybackErrorType.deviceError,
        audioUrl: _currentUrl,
        code: 'STOP_ERROR',
        originalError: e,
      );
    } catch (e) {
      throw AudioPlaybackException(
        'فشل في إيقاف الصوت: ${e.toString()}',
        AudioPlaybackErrorType.unknown,
        audioUrl: _currentUrl,
        code: 'STOP_ERROR',
        originalError: e,
      );
    }
  }

  /// Seek to a specific position in the audio
  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } on PlayerException catch (e) {
      throw AudioPlaybackException(
        'فشل في الانتقال إلى الموضع المحدد: ${e.message}',
        AudioPlaybackErrorType.deviceError,
        audioUrl: _currentUrl,
        code: 'SEEK_ERROR',
        originalError: e,
      );
    } catch (e) {
      throw AudioPlaybackException(
        'فشل في الانتقال إلى الموضع المحدد: ${e.toString()}',
        AudioPlaybackErrorType.unknown,
        audioUrl: _currentUrl,
        code: 'SEEK_ERROR',
        originalError: e,
      );
    }
  }

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    try {
      if (volume < 0.0 || volume > 1.0) {
        throw const AudioPlaybackException(
          'مستوى الصوت يجب أن يكون بين 0.0 و 1.0',
          AudioPlaybackErrorType.unknown,
          code: 'INVALID_VOLUME',
        );
      }
      await _audioPlayer.setVolume(volume);
    } on PlayerException catch (e) {
      throw AudioPlaybackException(
        'فشل في تعديل مستوى الصوت: ${e.message}',
        AudioPlaybackErrorType.deviceError,
        code: 'VOLUME_ERROR',
        originalError: e,
      );
    } catch (e) {
      if (e is AudioPlaybackException) rethrow;
      throw AudioPlaybackException(
        'فشل في تعديل مستوى الصوت: ${e.toString()}',
        AudioPlaybackErrorType.unknown,
        code: 'VOLUME_ERROR',
        originalError: e,
      );
    }
  }

  /// Get current playback position
  Duration get position => _audioPlayer.position;

  /// Get total duration
  Duration? get duration => _audioPlayer.duration;

  /// Get playback state
  PlayerState get playerState => _audioPlayer.playerState;

  /// Get processing state
  ProcessingState get processingState => _audioPlayer.processingState;

  /// Dispose of the audio player
  Future<void> dispose() async {
    try {
      await _audioPlayer.dispose();
      isPlaying = false;
      _currentUrl = null;
    } catch (e) {
      // Log error but don't throw to avoid preventing disposal
    }
  }

  /// Map PlayerException to our AudioPlaybackErrorType
  AudioPlaybackErrorType _mapPlayerExceptionType(PlayerException exception) {
    // This is a simplified mapping - you may need to adjust based on actual exception types
    final message = exception.message?.toLowerCase() ?? '';
    if (message.contains('network')) {
      return AudioPlaybackErrorType.networkError;
    } else if (message.contains('codec')) {
      return AudioPlaybackErrorType.codecNotSupported;
    } else if (message.contains('permission')) {
      return AudioPlaybackErrorType.permissionDenied;
    } else {
      return AudioPlaybackErrorType.deviceError;
    }
  }
}
