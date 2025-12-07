import 'dart:math' as math;
import '../../core/result.dart';
import 'calculator_error.dart';
/// Calculator for Liver Iron Concentration (LIC) using modified Garbowski equation
///
/// Formula: LIC = 31.94 / (T2*)^1.014
/// where T2* is in milliseconds and LIC is in mg Fe/g dry weight
///
/// Reference: Garbowski et al. (2014) - Modified equation for liver iron quantification <https://pubmed.ncbi.nlm.nih.gov/24915987/>
class LicCalculator {
  // Constants for the modified Garbowski equation
  static const double _coefficient = 31.94;
  static const double _exponent = 1.014;

  Result<Map<String, dynamic>, CalculatorError> getLicDataFromString({
    required String t2StarMsLtLobe,
    required String t2StarMsRtAntLobe,
    required String t2StarMsRtPostLobe,
    }) {
    
    // Parse T2* value (Left hepatic Lobe)
    double t2StarMsLtLobeParsed;
    try {
      t2StarMsLtLobeParsed = double.parse(t2StarMsLtLobe);
    } catch (e) {
      return Failure(ParseError('T2* value of Left hepatic lobe', t2StarMsLtLobe));
    }

    // Parse T2* value (right anterior hepatic lobe)
    double t2StarMsRtAntLobeParsed;
    try {
      t2StarMsRtAntLobeParsed = double.parse(t2StarMsRtAntLobe);
    } catch (e) {
      return Failure(ParseError('T2* value of Right anterior hepatic lobe', t2StarMsRtAntLobe));
    }

    // Parse T2* value (right posterior hepatic lobe)
    double t2StarMsRtPostLobeParsed;
    try {
      t2StarMsRtPostLobeParsed = double.parse(t2StarMsRtPostLobe);
    } catch (e) {
      return Failure(ParseError('T2* value of Right posterior hepatic lobe', t2StarMsRtPostLobe));
    }

    // Validate and calculate
    try {
      final data = getLicData(
        t2StarMsLtLobe: t2StarMsLtLobeParsed,
        t2StarMsRtAntLobe: t2StarMsRtAntLobeParsed,
        t2StarMsRtPostLobe: t2StarMsRtPostLobeParsed, 
      );
      return Success(data);
    } on ArgumentError catch (e) {
      return Failure(ValidationError(e.message ?? 'Validation failed'));
    } catch (e) {
      return Failure(CalculationError('Unexpected error: $e'));
    }

  }

  /// Calculates LIC data from T2* value
  /// 
  /// [t2StarMsLtLobe] - T2* value in milliseconds from left hepatic lobe
  /// [t2StarMsRtAntLobe] - T2* value in milliseconds from right anterior hepatic lobe
  /// [t2StarMsRtPostLobe] - T2* value in milliseconds from right posterior hepatic lobe
  /// 
  Map<String, dynamic> getLicData({
    required double t2StarMsLtLobe,
    required double t2StarMsRtAntLobe,
    required double t2StarMsRtPostLobe,
  }) {
    final double licLtLobe = calcLic(t2StarMs: t2StarMsLtLobe);
    final double licRtAntLobe = calcLic(t2StarMs: t2StarMsRtAntLobe);
    final double licRtPostLobe = calcLic(t2StarMs: t2StarMsRtPostLobe);
    return {
      "t2StarMsLtLobe": t2StarMsLtLobe,
      "t2StarMsRtAntLobe": t2StarMsRtAntLobe,
      "t2StarMsRtPostLobe": t2StarMsRtPostLobe,
      "licLtLobe": licLtLobe,
      "licRtAntLobe": licRtAntLobe, 
      "licRtPostLobe": licRtPostLobe, 
      "licLtLobeTwoDecimal": licLtLobe.toStringAsFixed(2), 
      "licRtAntLobeTwoDecimal": licRtAntLobe.toStringAsFixed(2),
      "licRtPostLobeTwoDecimal": licRtPostLobe.toStringAsFixed(2),
    };
  }


  /// Calculates LIC from T2* value
  ///
  /// [t2StarMs] - T2* value in milliseconds (must be positive)
  ///
  /// Returns LIC in mg Fe/g dry weight
  ///
  /// Throws [ArgumentError] if T2* is not positive
  ///
  /// Example:
  /// ```dart
  /// final calculator = LicCalculator();
  /// final lic = calculator.calcLic(10.0); // Returns ~3.19
  /// ```
  double calcLic({required double t2StarMs}) {
    _validateT2Star(t2StarMs);
    
    // LIC = 31.94 / (T2*)^1.014
    final double lic = _coefficient / math.pow(t2StarMs, _exponent);
    
    return lic;
  }


  /// Calculates T2* from a given LIC value (inverse calculation)
  ///
  /// [licMgPerG] - LIC value in mg Fe/g dry weight (must be positive)
  ///
  /// Returns T2* in milliseconds
  ///
  /// Throws [ArgumentError] if LIC is not positive
  ///
  /// Example:
  /// ```dart
  /// final t2Star = calculator.calcT2Star(3.19); // Returns ~10.0
  /// ```
  double calcT2Star(double licMgPerG) {
    if (licMgPerG <= 0) {
      throw ArgumentError('LIC must be positive, got: $licMgPerG');
    }
    
    // T2* = (31.94 / LIC)^(1/1.014)
    final double t2Star = math.pow(_coefficient / licMgPerG, 1.0 / _exponent).toDouble();
    
    return t2Star;
  }


  // Validation helper
  void _validateT2Star(double t2StarMs) {
    if (t2StarMs <= 0) {
      throw ArgumentError('T2* must be positive, got: $t2StarMs');
    }
    if (t2StarMs.isNaN) {
      throw ArgumentError('T2* cannot be NaN');
    }
    if (t2StarMs.isInfinite) {
      throw ArgumentError('T2* cannot be infinite');
    }
  }
}