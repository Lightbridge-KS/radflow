/// Base sealed class for calculator errors
///
/// This sealed class hierarchy provides type-safe error handling for calculator operations.
/// All possible error types are defined as subclasses, enabling exhaustive pattern matching.
sealed class CalculatorError {
  final String message;
  const CalculatorError(this.message);
}

/// Input parsing failed (non-numeric input, invalid format)
///
/// Thrown when user input cannot be parsed into a valid number.
/// Contains the field name and the invalid input for better error messages.
final class ParseError extends CalculatorError {
  final String fieldName;
  final String input;

  ParseError(this.fieldName, this.input)
      : super('$fieldName must be a valid number');
}

/// Business rule validation failed
///
/// Thrown when input values are valid numbers but violate business rules.
/// Examples: negative dimensions, wrong value count, impossible conditions.
final class ValidationError extends CalculatorError {
  ValidationError(super.message);
}

/// Mathematical operation error
///
/// Thrown when a calculation fails unexpectedly.
/// This is a catch-all for unexpected errors during computation.
final class CalculationError extends CalculatorError {
  CalculationError(super.message);
}
