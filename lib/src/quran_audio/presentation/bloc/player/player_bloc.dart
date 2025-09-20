import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_mp3/core/error/exceptions.dart';

part 'player_state.dart';
part 'player_event.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<String> _audioList;
  int _currentIndex = 0;
  bool _isRandom = false;

  AudioBloc({required List<String> audioList})
      : _audioList = audioList,
        super(AudioState(
          audioList: audioList,
          currentIndex: 0,
          totalDuration: Duration.zero,
          position: Duration.zero,
          isRandom: false,
        )) {
    _initAudio();

    on<Play>(_onPlay);
    on<Pause>(_onPause);
    on<Stop>(_onStop);
    on<Seek>(_onSeek);
    on<RandomPlay>(_onRandomPlay);
    on<LoadAudio>(_onLoadAudio);
    on<AudioError>(_onAudioError);
    on<ClearError>(_onClearError);
    on<DurationChanged>(_onDurationChanged);
    on<PositionChanged>(_onPositionChanged);
    on<PlayerStateChanged>(_onPlayerStateChanged);
  }

  void _onPlay(Play event, Emitter<AudioState> emit) async {
    try {
      await _play();
      emit(state.copyWith(clearError: true));
    } catch (e) {
      add(AudioError(
        message: 'فشل في تشغيل الصوت',
        code: 'PLAY_ERROR',
      ));
    }
  }

  void _onPause(Pause event, Emitter<AudioState> emit) async {
    try {
      await _pause();
      emit(state.copyWith(clearError: true));
    } catch (e) {
      add(AudioError(
        message: 'فشل في إيقاف الصوت مؤقتاً',
        code: 'PAUSE_ERROR',
      ));
    }
  }

  void _onStop(Stop event, Emitter<AudioState> emit) async {
    try {
      await _stop();
      emit(state.copyWith(clearError: true));
    } catch (e) {
      add(AudioError(
        message: 'فشل في إيقاف الصوت',
        code: 'STOP_ERROR',
      ));
    }
  }

  void _onSeek(Seek event, Emitter<AudioState> emit) async {
    try {
      await _seek(event.position);
      emit(state.copyWith(clearError: true));
    } catch (e) {
      add(AudioError(
        message: 'فشل في الانتقال إلى الموضع المحدد',
        code: 'SEEK_ERROR',
      ));
    }
  }

  void _onRandomPlay(RandomPlay event, Emitter<AudioState> emit) {
    try {
      _toggleRandom();
      emit(state.copyWith(
        isRandom: _isRandom,
        currentIndex: _currentIndex,
        clearError: true,
      ));
    } catch (e) {
      add(AudioError(
        message: 'فشل في تفعيل التشغيل العشوائي',
        code: 'RANDOM_PLAY_ERROR',
      ));
    }
  }

  void _onLoadAudio(LoadAudio event, Emitter<AudioState> emit) async {
    try {
      if (event.audioUrl.isEmpty) {
        throw const AudioPlaybackException(
          'URL الصوت فارغ',
          AudioPlaybackErrorType.invalidUrl,
          code: 'EMPTY_URL',
        );
      }

      await _audioPlayer.setUrl(event.audioUrl);
      emit(state.copyWith(clearError: true));
    } on FormatException {
      add(AudioError(
        message: 'تنسيق URL الصوت غير صحيح',
        code: 'INVALID_URL_FORMAT',
      ));
    } on AudioPlaybackException catch (e) {
      add(AudioError(
        message: e.message,
        code: e.code,
      ));
    } catch (e) {
      add(AudioError(
        message: 'فشل في تحميل الصوت',
        code: 'LOAD_AUDIO_ERROR',
      ));
    }
  }

  void _onAudioError(AudioError event, Emitter<AudioState> emit) {
    emit(state.copyWith(
      hasError: true,
      errorMessage: event.message,
      errorCode: event.code,
    ));
  }

  void _onClearError(ClearError event, Emitter<AudioState> emit) {
    emit(state.copyWith(clearError: true));
  }

  void _onDurationChanged(DurationChanged event, Emitter<AudioState> emit) {
    emit(state.copyWith(totalDuration: event.duration));
  }

  void _onPositionChanged(PositionChanged event, Emitter<AudioState> emit) {
    emit(state.copyWith(position: event.duration));
  }

  void _onPlayerStateChanged(
      PlayerStateChanged event, Emitter<AudioState> emit) {
    if (event.playerState != null) {
      emit(state.copyWith(progressState: event.playerState!.processingState));
    }
  }

  void _initAudio() {
    _audioPlayer.durationStream.listen(
      (updatedDuration) {
        add(DurationChanged(duration: updatedDuration));
      },
      onError: (error) {
        add(AudioError(
          message: 'خطأ في تدفق مدة الصوت',
          code: 'DURATION_STREAM_ERROR',
        ));
      },
    );

    _audioPlayer.positionStream.listen(
      (updatedPosition) {
        add(PositionChanged(duration: updatedPosition));
      },
      onError: (error) {
        add(AudioError(
          message: 'خطأ في تدفق موضع الصوت',
          code: 'POSITION_STREAM_ERROR',
        ));
      },
    );

    _audioPlayer.playerStateStream.listen(
      (playerState) {
        add(PlayerStateChanged(playerState: playerState));
      },
      onError: (error) {
        add(AudioError(
          message: 'خطأ في تدفق حالة المشغل',
          code: 'PLAYER_STATE_STREAM_ERROR',
        ));
      },
    );
  }

  Future<void> _play() async {
    try {
      await _audioPlayer.play();
    } catch (e) {
      throw AudioPlaybackException(
        'فشل في تشغيل الصوت: ${e.toString()}',
        AudioPlaybackErrorType.unknown,
        code: 'PLAY_FAILED',
        originalError: e,
      );
    }
  }

  Future<void> _pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      throw AudioPlaybackException(
        'فشل في إيقاف الصوت مؤقتاً: ${e.toString()}',
        AudioPlaybackErrorType.unknown,
        code: 'PAUSE_FAILED',
        originalError: e,
      );
    }
  }

  Future<void> _stop() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      throw AudioPlaybackException(
        'فشل في إيقاف الصوت: ${e.toString()}',
        AudioPlaybackErrorType.unknown,
        code: 'STOP_FAILED',
        originalError: e,
      );
    }
  }

  Future<void> _seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      throw AudioPlaybackException(
        'فشل في الانتقال إلى الموضع المحدد: ${e.toString()}',
        AudioPlaybackErrorType.unknown,
        code: 'SEEK_FAILED',
        originalError: e,
      );
    }
  }

  void _toggleRandom() {
    _isRandom = !_isRandom;
    if (_isRandom) {
      _currentIndex = _getRandomIndex();
    }
  }

  int _getRandomIndex() {
    return _currentIndex == _audioList.length - 1 ? 0 : _currentIndex + 1;
  }

  @override
  Future<void> close() async {
    try {
      await _audioPlayer.dispose();
    } catch (e) {
      // Log error but don't throw to avoid preventing bloc closure
    }
    return super.close();
  }
}
