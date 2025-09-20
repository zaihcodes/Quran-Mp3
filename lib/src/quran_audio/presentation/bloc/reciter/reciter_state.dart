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
  final String? errorMessage; // Added error message field
  final String? errorCode; // Added error code for specific error handling

  const ReciterState({
    this.reciters = const [],
    this.filtredReciters = const [],
    this.selectedReciter,
    required this.status,
    this.errorMessage,
    this.errorCode,
  });

  ReciterState copyWith({
    List<Reciter>? reciters,
    List<Reciter>? filtredReciters,
    Reciter? selectedReciter, // Ensure consistency in naming
    required ReciterStateStatus status,
    String? errorMessage,
    String? errorCode,
    bool clearError = false, // Helper to clear error state
  }) {
    return ReciterState(
      reciters: reciters ?? this.reciters,
      filtredReciters: filtredReciters ?? this.filtredReciters,
      selectedReciter: selectedReciter ?? this.selectedReciter,
      status: status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
    );
  }

  @override
  List<Object?> get props =>
      [reciters, filtredReciters, selectedReciter, status, errorMessage, errorCode];
}
