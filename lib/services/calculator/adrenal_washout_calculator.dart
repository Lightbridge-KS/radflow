
import '../../core/result.dart';
import 'calculator_error.dart';

/// Adrenal CT Washout Calculator Business Logic
///
/// Calculates Relative Percentage Washout (RPW) and Absolute Percentage Washout (APW)
/// for characterizing adrenal lesions on CT imaging.
///
/// **Clinical Context:**
/// - RPW >40% suggests benign adenoma
/// - APW >60% suggests benign adenoma
/// - Non-contrast phase is optional; if not provided, only RPW is calculated
///
/// **Formulas:**
/// - RPW = (Enhanced - Delayed) / Enhanced × 100
/// - APW = (Enhanced - Delayed) / (Enhanced - Non-contrast) × 100
class AdrenalWashoutCalculator {

  /// Parses string inputs and calculates adrenal washout data
  ///
  /// Returns a [Result] containing either the calculated data or a specific error.
  /// Possible errors: [ParseError], [ValidationError], [CalculationError].
  static Result<Map<String, dynamic>, CalculatorError> getAdrenalWashoutDataFromString({
    String? nc,
    required String enh,
    required String delayed,
    }) {
    // Parse non-contrast (optional)
    double? ncParsed;
    if (nc != null && nc.trim().isNotEmpty) {
      try {
        ncParsed = double.parse(nc);
      } catch (e) {
        return Failure(ParseError('Pre-contrast HU', nc));
      }
    }

    // Parse enhanced (required)
    double enhParsed;
    try {
      enhParsed = double.parse(enh);
    } catch (e) {
      return Failure(ParseError('Enhanced HU', enh));
    }

    // Parse delayed (required)
    double delayedParsed;
    try {
      delayedParsed = double.parse(delayed);
    } catch (e) {
      return Failure(ParseError('Delayed HU', delayed));
    }

    // Validate and calculate
    try {
      final data = getAdrenalWashoutData(
        nc: ncParsed,
        enh: enhParsed,
        delayed: delayedParsed,
      );
      return Success(data);
    } on ArgumentError catch (e) {
      return Failure(ValidationError(e.message ?? 'Validation failed'));
    } catch (e) {
      return Failure(CalculationError('Unexpected error: $e'));
    }

  }



  /// Calculates adrenal washout data from numeric inputs
  ///
  /// Returns a Map containing:
  /// - Raw values: `nc`, `enh`, `delayed`, `rpw`, `apw`
  /// - Formatted values: `rpwOneDecimal`, `apwOneDecimal`
  ///
  /// The `nc` (non-contrast) parameter is optional. If provided, APW will be calculated.
  /// Throws [ArgumentError] for invalid input combinations or negative washout.
  static Map<String, dynamic>  getAdrenalWashoutData({
    double? nc,
    required double enh,
    required double delayed,
  }) {
    final double rpw = calcRpw(enh: enh, delayed: delayed);

    final double? apw = nc != null ? calcApw(nc: nc, enh: enh, delayed: delayed) : null;

    return {
      "nc": nc,
      "enh": enh,
      "delayed": delayed,
      "rpw": rpw,
      "apw": apw, 
      "rpwOneDecimal": rpw.toStringAsFixed(1),
      "apwOneDecimal": apw?.toStringAsFixed(1)
    };
  }

  /// Calculates the Absolute Percentage Washout (APW)
  ///
  /// Formula: APW = (Enhanced - Delayed) / (Enhanced - Non-contrast) × 100
  ///
  /// Throws [ArgumentError] if:
  /// - Enhanced and non-contrast values are equal (division by zero)
  /// - Delayed value is greater than enhanced value (negative washout)
  static double calcApw({
    required double nc,
    required double enh,
    required double delayed,
  }) {
    if (enh == nc) {
      throw ArgumentError('Enhanced and non-contrast values cannot be equal');
    }
    if (delayed > enh) {
      throw ArgumentError('Delayed value cannot be greater than enhanced value (negative washout)');
    }
    final double apw = (enh - delayed) / (enh - nc) * 100;
    return apw;
  }

  /// Calculates the Relative Percentage Washout (RPW)
  ///
  /// Formula: RPW = (Enhanced - Delayed) / Enhanced × 100
  ///
  /// Throws [ArgumentError] if:
  /// - Enhanced value is zero (division by zero)
  /// - Delayed value is greater than enhanced value (negative washout)
  static double calcRpw({required double enh, required double delayed}) {
    if (enh == 0) {
      throw ArgumentError('Enhanced value cannot be zero');
    }
    if (delayed > enh) {
      throw ArgumentError('Delayed value cannot be greater than enhanced value (negative washout)');
    }
    return (enh - delayed) / enh * 100;
  }
}

/// For Testing
// void main() {
//   print(AdrenalWashoutCalculator.calcApw(nc: 10, enh: 100, delayed: 60));
//   print(AdrenalWashoutCalculator.calcRpw(enh: 100, delayed: 60));
//   print(AdrenalWashoutCalculator.calculate(enh: 100, delayed: 60));
//   print(AdrenalWashoutCalculator.calculate(nc: 10, enh: 100, delayed: 60));
// }
