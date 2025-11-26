import 'shared/_statistics.dart';
import 'shared/_parser.dart';

/// Calculator for spine height loss and compression fracture assessment
///
/// **Methods**
///
/// * [spineHeightLossFromString] - Calculate spine height loss from string inputs
/// * [spineHeightLoss] - Calculate spine height loss from numeric lists
/// * [getSpineHeightLossDataFromString] - Return data Map for template rendering from string inputs
/// * [getSpineHeightLossData] - Return data Map with all calculated values for template rendering
class SpineCalculator {


  /// Returns spine height loss data as a Map for template rendering from string inputs
  ///
  /// Parameters
  /// ----------
  /// normalCm : String representation of normal vertebral heights
  /// collapsedCM : String representation of collapsed vertebral heights
  ///
  /// Returns
  /// -------
  /// `Map<String, dynamic>?`
  ///     Data map with keys: diagnosis, lossPercent, lossPercentRounded, normalMean, collapsedMean
  ///     Returns null if input cannot be parsed or if loss is negative
  static Map<String, dynamic>? getSpineHeightLossDataFromString({required String normalCm, required String collapsedCM}) {
    // Parse normal heights
    dynamic normalParsed = parseStrToNumOrList(normalCm);
    if (normalParsed == "") {
      return null;
    }

    // Parse collapsed heights
    dynamic collapsedParsed = parseStrToNumOrList(collapsedCM);
    if (collapsedParsed == "") {
      return null;
    }

    // Convert to lists for consistency
    List<double> normalList = normalParsed is double ? [normalParsed] : normalParsed;
    List<double> collapsedList = collapsedParsed is double ? [collapsedParsed] : collapsedParsed;

    // Call existing method
    return getSpineHeightLossData(normalCm: normalList, collapsedCM: collapsedList);
  }

  /// Returns spine height loss data as a Map for template rendering
  ///
  /// Parameters
  /// ----------
  /// normalCm : List of normal vertebral heights in centimeters
  /// collapsedCM : List of collapsed vertebral heights in centimeters
  ///
  /// Returns
  /// -------
  /// `Map<String, dynamic>?`
  ///     Data map with keys:
  ///     - diagnosis : String - Severity classification of compression fracture
  ///     - lossPercent : double - Raw loss percentage
  ///     - lossPercentRounded : int - Rounded loss percentage
  ///     - normalMean : double - Mean of normal heights
  ///     - collapsedMean : double - Mean of collapsed heights
  ///     Returns null if collapsed height is greater than normal height (negative loss)
  static Map<String, dynamic>? getSpineHeightLossData({required List<double> normalCm, required List<double> collapsedCM}) {
    // Calculate mean if input as list
    double normalMean = Statistics.mean(normalCm);
    double collapsedMean = Statistics.mean(collapsedCM);

    // Calculate loss percentage
    double lossPercent = ((normalMean - collapsedMean) / normalMean) * 100;
    if (lossPercent < 0) {
      return null;
    }

    // Get diagnosis
    String diagnosis = _spineHeightLossDx(lossPercent: lossPercent);

    return {
      "diagnosis": diagnosis,
      "lossPercent": lossPercent,
      "lossPercentRounded": lossPercent.round(),
      "normalMean": normalMean,
      "collapsedMean": collapsedMean,
    };
  }

  /// Calculates spine height loss percentage and provides diagnostic assessment
  ///
  /// Parameters
  /// ----------
  /// normalCm : List of normal vertebral heights in centimeters
  /// collapsedCM : List of collapsed vertebral heights in centimeters
  ///
  /// Returns
  /// -------
  /// String
  ///     Formatted string with compression fracture diagnosis and height loss percentage
  ///
  /// Throws
  /// ------
  /// ArgumentError
  ///     If collapsed height is greater than normal height (negative loss)
  // static String spineHeightLoss({required List<double> normalCm, required List<double> collapsedCM}) {
  //   final data = spineHeightLossData(normalCm: normalCm, collapsedCM: collapsedCM);
  //   if (data == null) {
  //     return "";
  //   }

  //   return "${data['diagnosis']} compression fracture (${data['lossPercentRounded']}% height loss).";
  // }

  /// Determines compression fracture severity based on height loss percentage
  ///
  /// Parameters
  /// ----------
  /// lossPercent : double
  ///     Percentage of height loss
  ///
  /// Returns
  /// -------
  /// String
  ///     Severity classification of compression fracture
  ///
  /// Throws
  /// ------
  /// ArgumentError
  ///     If loss percentage is negative
  static String _spineHeightLossDx({required double lossPercent}) {
    // Negative case
    if (lossPercent < 0) {
      throw ArgumentError("`collapsedCM` must be less than `normalCm`");
    }
    
    String diagnosis;
    if (lossPercent < 20) {
      diagnosis = "Less than mild";
    } else if (lossPercent < 25) {
      diagnosis = "Mild";
    } else if (lossPercent == 25) {
      diagnosis = "Mild to moderate";
    } else if (lossPercent < 40) {
      diagnosis = "Moderate";
    } else if (lossPercent == 40) {
      diagnosis = "Moderate to severe";
    } else {
      diagnosis = "Severe";
    }
    
    return diagnosis;
  }
}