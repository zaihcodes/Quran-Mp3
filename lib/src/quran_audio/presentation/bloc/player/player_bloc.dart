import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

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
          // progressState: AudioPlayerState.STOPPED,
          isRandom: false,
        )) {
    _initAudio();

    // on<DurationChanged>(_durationChanged);
    // on<PositionChanged>(_positionChanged);
    // on<PlayerStateChanged>(_playerStateChanged);
  }

  // void _durationChanged(DurationChanged event, Emitter<AudioState> emit) {
  //   emit(state.copyWith(position: event.duration));
  // }

  // void _positionChanged(PositionChanged event, Emitter<AudioState> emit) {
  //   emit(state.copyWith(position: event.duration));
  // }

  // void _playerStateChanged(PlayerStateChanged event, Emitter<AudioState> emit) {
  //   emit(state.copyWith(progressState: event.playerState!.processingState));
  // }

  void _initAudio() {
    _audioPlayer.durationStream.listen((updatedDuration) {
      add(DurationChanged(duration: updatedDuration));
    });

    _audioPlayer.positionStream.listen((updatedPosition) {
      add(PositionChanged(duration: updatedPosition));
    });

    _audioPlayer.playerStateStream.listen((playerState) {
      add(PlayerStateChanged(playerState: playerState));
    });
  }

  @override
  Stream<AudioState> mapEventToState(AudioEvent event) async* {
    if (event is Play) {
      _play();
    } else if (event is Pause) {
      _pause();
    } else if (event is Stop) {
      _stop();
    } else if (event is Seek) {
      _seek(event.position);
    } else if (event is RandomPlay) {
      _toggleRandom();
    } else if (event is DurationChanged) {
      emit(state.copyWith(position: event.duration));
    } else if (event is PositionChanged) {
      emit(state.copyWith(position: event.duration));
    }
  }

  void _play() {
    _audioPlayer.play(); //_audioList[_currentIndex]
  }

  void _pause() {
    _audioPlayer.pause();
  }

  void _stop() {
    _audioPlayer.stop();
  }

  void _seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void _toggleRandom() {
    _isRandom = !_isRandom;
    if (_isRandom) {
      _currentIndex = _getRandomIndex();
    }
  }

  int _getRandomIndex() {
    return _currentIndex = _currentIndex == null
        ? 0
        : _currentIndex == _audioList.length - 1
            ? 0
            : _currentIndex + 1;
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }
}
