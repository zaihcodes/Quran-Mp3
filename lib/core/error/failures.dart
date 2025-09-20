import 'package:equatable/equatable.dart';

/// Base failure class for representing errors in the application
/// Failures are used to represent errors at the domain layer
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Failure when data cannot be loaded or parsed
class DataFailure extends Failure {
  const DataFailure(String message, {String? code}) : super(message, code: code);
}

/// Failure when JSON parsing fails
class JsonParsingFailure extends Failure {
  const JsonParsingFailure(String message, {String? code}) : super(message, code: code);
}

/// Failure when assets cannot be loaded
class AssetLoadingFailure extends Failure {
  const AssetLoadingFailure(String message, {String? code}) : super(message, code: code);
}

/// Failure when audio operations fail
class AudioFailure extends Failure {
  const AudioFailure(String message, {String? code}) : super(message, code: code);
}

/// Failure when network operations fail
class NetworkFailure extends Failure {
  const NetworkFailure(String message, {String? code}) : super(message, code: code);
}

/// Failure when repository operations fail
class RepositoryFailure extends Failure {
  const RepositoryFailure(String message, {String? code}) : super(message, code: code);
}

/// Failure when use case operations fail
class UseCaseFailure extends Failure {
  const UseCaseFailure(String message, {String? code}) : super(message, code: code);
}

/// General failure for unexpected errors
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(String message, {String? code}) : super(message, code: code);
}