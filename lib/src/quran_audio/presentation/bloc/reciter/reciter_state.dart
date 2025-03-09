part of 'reciter_bloc.dart';

enum ReciterStateStatus {
  initial,
  loading,
  loaded,
  loadingReciter,
  loadedReciter,
  error,
}

class ReciterState extends Equatable {
  final List<Reciter> reciters;
  final List<Reciter> filtredReciters;
  final Reciter? selectedReciter; // More descriptive name for clarity
  final ReciterStateStatus status;

  const ReciterState({
    this.reciters = const [],
    this.filtredReciters = const [],
    this.selectedReciter,
    required this.status,
  });

  ReciterState copyWith({
    List<Reciter>? reciters,
    List<Reciter>? filtredReciters,
    Reciter? selectedReciter, // Ensure consistency in naming
    required ReciterStateStatus status,
  }) {
    return ReciterState(
      reciters: reciters ?? this.reciters,
      filtredReciters: filtredReciters ?? this.filtredReciters,
      selectedReciter: selectedReciter ?? this.selectedReciter,
      status: status,
    );
  }

  @override
  List<Object?> get props =>
      [reciters, filtredReciters, selectedReciter, status];
}
