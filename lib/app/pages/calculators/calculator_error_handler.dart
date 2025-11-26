import 'package:flutter/material.dart';
import '../../../services/calculator/calculator_error.dart';

/// Calculator-specific error display utility
///
/// Provides consistent error feedback for calculator validation and template errors
/// using Material 3 SnackBars.
class CalculatorErrorHandler {
  /// Shows error based on CalculatorError with specific message
  static void showCalculatorError(BuildContext context, CalculatorError error) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Shows a general error SnackBar with custom message
  static void showError(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// Shows a warning SnackBar for invalid calculator input
  static void showInvalidInput(BuildContext context) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid input. Please check your values and try again.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// Shows an error SnackBar for template rendering failures
  static void showTemplateError(BuildContext context) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Template rendering failed. Please check template settings.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
