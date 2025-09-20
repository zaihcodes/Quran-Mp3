part of 'player_bloc.dart';

class AudioState extends Equatable {
  final List<String> audioList;
  final int currentIndex;
  final Duration totalDuration;
  final Duration position;
  final ProcessingState progressState;
  final bool isRandom;
  final bool isLoop;
  final String? errorMessage; // Added error message field
  final String? errorCode; // Added error code for specific error handling
  final bool hasError; // Added flag to indicate error state

  const AudioState({
    required this.audioList,
    required this.currentIndex,
    required this.totalDuration,
    this.position = Duration.zero,
    this.progressState = ProcessingState.idle,
    this.isRandom = false,
    this.isLoop = false,
    this.errorMessage,
    this.errorCode,
    this.hasError = false,
  });

  @override
  List<Object?> get props => [
        audioList,
        currentIndex,
        totalDuration,
        position,
        progressState,
        isRandom,
        isLoop,
        errorMessage,
        errorCode,
        hasError,
      ];

  AudioState copyWith({
    List<String>? audioList,
    int? currentIndex,
    Duration? totalDuration,
    Duration? position,
    ProcessingState? progressState,
    bool? isRandom,
    bool? isLoop,
    String? errorMessage,
    String? errorCode,
    bool? hasError,
    bool clearError = false, // Helper to clear error state
  }) {
    return AudioState(
        audioList: audioList ?? this.audioList,
        currentIndex: currentIndex ?? this.currentIndex,
        totalDuration: totalDuration ?? this.totalDuration,
        position: position ?? this.position,
        progressState: progressState ?? this.progressState,
        isRandom: isRandom ?? this.isRandom,
        isLoop: isLoop ?? this.isLoop,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
        errorCode: clearError ? null : (errorCode ?? this.errorCode),
        hasError: clearError ? false : (hasError ?? this.hasError));
  }
}

class AudioInitial extends AudioState {
  const AudioInitial({
    super.audioList = const [],
    super.currentIndex = 0,
    super.totalDuration = Duration.zero,
  });
}
