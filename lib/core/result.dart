/// Represents the result of an operation that can either succeed or fail
///
/// This sealed class provides type-safe error handling with exhaustive pattern matching.
/// Use [Success] when the operation completes successfully, and [Failure] when it fails.
///
/// Example:
/// ```dart
/// Result<int, String> divide(int a, int b) {
///   if (b == 0) return Failure('Division by zero');
///   return Success(a ~/ b);
/// }
///
/// final result = divide(10, 2);
/// switch (result) {
///   case Success(value: final v):
///     print('Result: $v');
///   case Failure(error: final e):
///     print('Error: $e');
/// }
/// ```
sealed class Result<T, E> {
  const Result();
}

/// Success case containing the result value
final class Success<T, E> extends Result<T, E> {
  final T value;
  const Success(this.value);
}

/// Failure case containing the error
final class Failure<T, E> extends Result<T, E> {
  final E error;
  const Failure(this.error);
}

/// Extension methods for convenient Result handling
extension ResultExtensions<T, E> on Result<T, E> {
  /// Returns true if this is a Success
  bool get isSuccess => this is Success<T, E>;

  /// Returns true if this is a Failure
  bool get isFailure => this is Failure<T, E>;

  /// Gets the success value or null if this is a Failure
  T? get valueOrNull => switch (this) {
        Success(value: final v) => v,
        Failure() => null,
      };

  /// Gets the error or null if this is a Success
  E? get errorOrNull => switch (this) {
        Success() => null,
        Failure(error: final e) => e,
      };
}
