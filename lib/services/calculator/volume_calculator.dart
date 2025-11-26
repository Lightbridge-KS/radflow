import 'dart:math' as math;
import 'shared/_parser.dart';

/// Calculator for medical volume measurements and assessments.
///
/// Provides static methods for calculating volumes of ellipsoid structures
/// commonly encountered in medical imaging, with diagnostic interpretation.
///
/// **Primary Use Cases**
///
/// * Prostate gland volume measurement from 3-axis dimensions
/// * Generic ellipsoid volume calculations
///
/// **Methods**
///
/// * [prostateVolumeFromString] - Parse string input and calculate prostate volume with diagnosis
/// * [prostateVolume] - Calculate prostate volume and diagnosis from numeric dimensions
/// * [getProstateVolumeDataFromString] - Parse string input and return data Map for template rendering
/// * [getProstateVolumeData] - Return data Map with all calculated values for template rendering
/// * [ellipsoidVolume] - Calculate volume of an ellipsoid from 3 perpendicular diameters
///
/// **Example**
///
/// ```dart
/// // From string input (comma or space separated)
/// String result = VolumeCalculator.prostateVolumeFromString("4.5, 3.2, 3.8");
/// // Returns: "Prominent size of prostate gland, measuring 29 ml in volume."
///
/// // From numeric values
/// String result = VolumeCalculator.prostateVolume(4.5, 3.2, 3.8);
/// // Returns: "Prominent size of prostate gland, measuring 29 ml in volume."
///
/// // Generic ellipsoid volume
/// double volume = VolumeCalculator.ellipsoidVolume(4.5, 3.2, 3.8);
/// // Returns: 28.6... (in cubic units)
/// ```
class VolumeCalculator {

  /// Returns prostate volume data as a Map for template rendering from string input.
  ///
  /// Parses a string containing 3 perpendicular diameters (in cm) and returns
  /// a Map with all calculated values for use in customizable templates.
  ///
  /// **Parameters**
  ///
  /// * `input` : String
  ///     Three perpendicular diameters in cm, separated by commas and/or spaces.
  ///
  /// **Returns**
  ///
  /// * `Map<String, dynamic>?` - Data map with keys: diagnosis, volume, volumeRaw, d1, d2, d3
  /// * null if input cannot be parsed or doesn't contain exactly 3 dimensions
  ///
  /// **Examples**
  ///
  /// ```dart
  /// var data = getProstateVolumeDataFromString("4.5, 3.2, 3.8");
  /// // Returns: {diagnosis: "Prominent", volume: 29, volumeRaw: 28.6..., d1: 4.5, d2: 3.2, d3: 3.8}
  /// ```
  static Map<String, dynamic>? getProstateVolumeDataFromString(String input) {
    dynamic parsed = parseStrToNumOrList(input);

    if (parsed == "") {
      return null;
    }

    try {
      List<double> dim = parsed is double ? [parsed] : parsed;

      if (dim.length != 3) {
        return null;
      }

      return getProstateVolumeData(dim[0], dim[1], dim[2]);
    } catch (e) {
      return null;
    }
  }

  /// Returns prostate volume data as a Map for template rendering.
  ///
  /// Computes prostate volume and diagnosis, returning all values as a Map
  /// for use in customizable Mustache templates.
  ///
  /// **Parameters**
  ///
  /// * `d1` : double - First perpendicular diameter in cm
  /// * `d2` : double - Second perpendicular diameter in cm
  /// * `d3` : double - Third perpendicular diameter in cm
  ///
  /// **Returns**
  ///
  /// * `Map<String, dynamic>` with keys:
  ///   - `diagnosis` : String - Size classification (Normal/Prominent/Enlarged)
  ///   - `volume` : int - Rounded volume in ml
  ///   - `volumeRaw` : double - Raw calculated volume (unrounded)
  ///   - `d1`, `d2`, `d3` : double - Input diameters in cm
  ///
  /// **Examples**
  ///
  /// ```dart
  /// var data = getProstateVolumeData(4.5, 3.2, 3.8);
  /// // Returns: {diagnosis: "Prominent", volume: 29, volumeRaw: 28.6..., d1: 4.5, d2: 3.2, d3: 3.8}
  /// ```
  static Map<String, dynamic> getProstateVolumeData(double d1, double d2, double d3) {
    double volumeRaw = ellipsoidVolume(d1, d2, d3);
    int volume = volumeRaw.round();
    String diagnosis;

    if (volumeRaw < 25) {
      diagnosis = "Normal";
    } else if (volumeRaw == 25) {
      diagnosis = "Normal or Prominent";
    } else if (volumeRaw < 40) {
      diagnosis = "Prominent";
    } else if (volumeRaw == 40) {
      diagnosis = "Prominent or Enlarged";
    } else {
      diagnosis = "Enlarged";
    }

    return {
      "diagnosis": diagnosis,
      "volume": volume,
      "volumeRaw": volumeRaw,
      "d1": d1,
      "d2": d2,
      "d3": d3,
    };
  }

  /// Calculates prostate volume and provides diagnostic assessment from numeric dimensions.
  ///
  /// Computes prostate volume using the ellipsoid formula and returns a formatted
  /// diagnostic statement with size classification based on established criteria.
  ///
  /// **Parameters**
  ///
  /// * `d1` : double - First perpendicular diameter in cm
  /// * `d2` : double - Second perpendicular diameter in cm
  /// * `d3` : double - Third perpendicular diameter in cm
  ///
  /// **Returns**
  ///
  /// * `String` - Diagnostic statement: "{Size} size of prostate gland, measuring {volume} ml in volume."
  ///     where Size is Normal, Prominent, or Enlarged
  ///
  /// **Diagnostic Criteria**
  ///
  /// * < 25 ml: Normal
  /// * 25 ml: Normal or Prominent
  /// * 25-40 ml: Prominent
  /// * 40 ml: Prominent or Enlarged
  /// * > 40 ml: Enlarged
  ///
  /// **Examples**
  ///
  /// ```dart
  /// prostateVolume(4.5, 3.2, 3.8);
  /// // Returns: "Prominent size of prostate gland, measuring 29 ml in volume."
  ///
  /// prostateVolume(3.0, 2.5, 2.8);
  /// // Returns: "Normal size of prostate gland, measuring 11 ml in volume."
  ///
  /// prostateVolume(5.5, 4.8, 5.2);
  /// // Returns: "Enlarged size of prostate gland, measuring 72 ml in volume."
  /// ```
  static String prostateVolume(double d1, double d2, double d3) {
    final data = getProstateVolumeData(d1, d2, d3);
    return "${data['diagnosis']} size of prostate gland, measuring ${data['volume']} ml in volume.";
  }

  /// Calculates the volume of an ellipsoid from three perpendicular diameters.
  ///
  /// Uses the mathematical formula: V = (4/3) × π × (d1/2) × (d2/2) × (d3/2)
  /// 
  static double ellipsoidVolume(double d1, double d2, double d3) {
    return (4 / 3) * math.pi * (d1 / 2) * (d2 / 2) * (d3 / 2);
  }
}