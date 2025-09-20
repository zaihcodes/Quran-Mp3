/// Custom exceptions for the Quran Mp3 application
/// These exceptions provide specific error types for different failure scenarios

/// Base class for all application exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException(
    this.message, {
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AppException: $message';
}

/// Exception thrown when JSON data cannot be parsed
class JsonParsingException extends AppException {
  const JsonParsingException(
    String message, {
    String? code,
    dynamic originalError,
  }) : super(
          message,
          code: code,
          originalError: originalError,
        );

  @override
  String toString() => 'JsonParsingException: $message';
}

/// Exception thrown when a required asset file cannot be loaded
class AssetLoadingException extends AppException {
  final String assetPath;

  const AssetLoadingException(
    String message,
    this.assetPath, {
    String? code,
    dynamic originalError,
  }) : super(
          message,
          code: code,
          originalError: originalError,
        );

  @override
  String toString() => 'AssetLoadingException: $message (Path: $assetPath)';
}

/// Exception thrown when data cannot be found or is invalid
class DataNotFoundException extends AppException {
  final String dataType;
  final String? identifier;

  const DataNotFoundException(
    String message,
    this.dataType, {
    this.identifier,
    String? code,
    dynamic originalError,
  }) : super(
          message,
          code: code,
          originalError: originalError,
        );

  @override
  String toString() => 'DataNotFoundException: $message (Type: $dataType, ID: $identifier)';
}

/// Exception thrown when audio playback operations fail
class AudioPlaybackException extends AppException {
  final String? audioUrl;
  final AudioPlaybackErrorType errorType;

  const AudioPlaybackException(
    String message,
    this.errorType, {
    this.audioUrl,
    String? code,
    dynamic originalError,
  }) : super(
          message,
          code: code,
          originalError: originalError,
        );

  @override
  String toString() => 'AudioPlaybackException: $message (Type: $errorType, URL: $audioUrl)';
}

/// Types of audio playback errors
enum AudioPlaybackErrorType {
  networkError,
  invalidUrl,
  codecNotSupported,
  deviceError,
  permissionDenied,
  unknown,
}

/// Exception thrown when network operations fail
class NetworkException extends AppException {
  final int? statusCode;
  final String? url;

  const NetworkException(
    String message, {
    this.statusCode,
    this.url,
    String? code,
    dynamic originalError,
  }) : super(
          message,
          code: code,
          originalError: originalError,
        );

  @override
  String toString() => 'NetworkException: $message (Status: $statusCode, URL: $url)';
}

/// Exception thrown when repository operations fail
class RepositoryException extends AppException {
  final String operation;

  const RepositoryException(
    String message,
    this.operation, {
    String? code,
    dynamic originalError,
  }) : super(
          message,
          code: code,
          originalError: originalError,
        );

  @override
  String toString() => 'RepositoryException: $message (Operation: $operation)';
}

/// Exception thrown when use case operations fail
class UseCaseException extends AppException {
  final String useCase;

  const UseCaseException(
    String message,
    this.useCase, {
    String? code,
    dynamic originalError,
  }) : super(
          message,
          code: code,
          originalError: originalError,
        );

  @override
  String toString() => 'UseCaseException: $message (UseCase: $useCase)';
}