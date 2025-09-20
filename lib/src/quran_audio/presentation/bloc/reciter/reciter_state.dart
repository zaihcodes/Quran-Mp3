part of 'reciter_bloc.dart';

enum ReciterStateStatus {
  initial,
  loading,
  loaded,
  loadingGrouped,
  loadedGrouped,
  loadingReciter,
  loadedReciter,
  error,
}

class ReciterState extends Equatable {
  final List<Reciter> reciters;
  final List<Reciter> filtredReciters;
  final List<GroupedReciter> groupedReciters;
  final List<GroupedReciter> filteredGroupedReciters;
  final Reciter? selectedReciter; // More descriptive name for clarity
  final ReciterStateStatus status;
  final String? errorMessage; // Added error message field
  final String? errorCode; // Added error code for specific error handling

  const ReciterState({
    this.reciters = const [],
    this.filtredReciters = const [],
    this.groupedReciters = const [],
    this.filteredGroupedReciters = const [],
    this.selectedReciter,
    required this.status,
    this.errorMessage,
    this.errorCode,
  });

  ReciterState copyWith({
    List<Reciter>? reciters,
    List<Reciter>? filtredReciters,
    List<GroupedReciter>? groupedReciters,
    List<GroupedReciter>? filteredGroupedReciters,
    Reciter? selectedReciter, // Ensure consistency in naming
    required ReciterStateStatus status,
    String? errorMessage,
    String? errorCode,
    bool clearError = false, // Helper to clear error state
  }) {
    return ReciterState(
      reciters: reciters ?? this.reciters,
      filtredReciters: filtredReciters ?? this.filtredReciters,
      groupedReciters: groupedReciters ?? this.groupedReciters,
      filteredGroupedReciters: filteredGroupedReciters ?? this.filteredGroupedReciters,
      selectedReciter: selectedReciter ?? this.selectedReciter,
      status: status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
    );
  }

  @override
  List<Object?> get props =>
      [reciters, filtredReciters, groupedReciters, filteredGroupedReciters, selectedReciter, status, errorMessage, errorCode];
}
