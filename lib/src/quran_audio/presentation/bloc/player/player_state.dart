part of 'player_bloc.dart';

class AudioState extends Equatable {
  final List<String> audioList;
  final int currentIndex;
  final Duration totalDuration;
  Duration position;
  ProcessingState progressState;
  bool isRandom;
  bool isLoop;

  AudioState({
    required this.audioList,
    required this.currentIndex,
    required this.totalDuration,
    this.position = Duration.zero,
    this.progressState = ProcessingState.idle,
    this.isRandom = false,
    this.isLoop = false,
  });

  @override
  List<Object> get props => [
        audioList,
        currentIndex,
        totalDuration,
        position,
        progressState,
        isRandom,
        isLoop,
      ];

  AudioState copyWith({
    List<String>? audioList,
    int? currentIndex,
    Duration? totalDuration,
    Duration? position,
    ProcessingState? progressState,
    bool? isRandom,
    bool? isLoop,
  }) {
    return AudioState(
        audioList: audioList ?? this.audioList,
        currentIndex: currentIndex ?? this.currentIndex,
        totalDuration: totalDuration ?? this.totalDuration,
        position: position ?? this.position,
        progressState: progressState ?? this.progressState,
        isRandom: isRandom ?? this.isRandom,
        isLoop: isLoop ?? this.isLoop);
  }
}

class AudioInitial extends AudioState {
  AudioInitial(
      {super.audioList = const [],
      super.currentIndex = 0,
      super.totalDuration = Duration.zero});
}
