part of 'player_bloc.dart';

abstract class AudioEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Play extends AudioEvent {}

class Pause extends AudioEvent {}

class Stop extends AudioEvent {}

class Seek extends AudioEvent {
  final Duration position;

  Seek(this.position);

  @override
  List<Object> get props => [position];
}

class RandomPlay extends AudioEvent {}

class DurationChanged extends AudioEvent {
  final Duration? duration;
  DurationChanged({required this.duration});
}

class PositionChanged extends AudioEvent {
  final Duration? duration;
  PositionChanged({required this.duration});
}

class PlayerStateChanged extends AudioEvent {
  final PlayerState? playerState;
  PlayerStateChanged({required this.playerState});
}

class LoadAudio extends AudioEvent {
  final String audioUrl;

  LoadAudio({required this.audioUrl});

  @override
  List<Object> get props => [audioUrl];
}

class AudioError extends AudioEvent {
  final String message;
  final String? code;

  AudioError({required this.message, this.code});

  @override
  List<Object> get props => [message, code ?? ''];
}

class ClearError extends AudioEvent {}
