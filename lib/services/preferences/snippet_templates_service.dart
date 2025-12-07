import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

/// Metadata about a calculator's template variables
class CalculatorMetadata {
  final String id;
  final String name;
  final List<VariableInfo> availableVariables;
  final Map<String, dynamic> sampleData;

  CalculatorMetadata({
    required this.id,
    required this.name,
    required this.availableVariables,
    required this.sampleData,
  });
}

/// Information about a single template variable
class VariableInfo {
  final String name;
  final String description;

  VariableInfo(this.name, this.description);
}

/// Service for managing calculator snippet templates with SharedPreferencesAsync
///
/// Handles CRUD operations for user-customizable calculator output templates.
/// Falls back to default templates when no user customization exists.
///
/// **Example**
///
/// ```dart
/// final service = SnippetTemplatesService();
///
/// // Get template (returns user's custom or default)
/// final template = await service.getTemplate('prostate_volume');
///
/// // Save custom template
/// await service.saveTemplate('prostate_volume', 'Custom {{diagnosis}} text');
///
/// // Reset to default
/// await service.resetToDefault('prostate_volume');
/// ```
class SnippetTemplatesService {
  static const String _keyPrefix = 'snippet_template_';
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  /// Calculator ID constants for type safety
  static const String prostateVolumeId = 'prostate_volume';
  static const String spineHeightLossId = 'spine_height_loss';
  static const String adrenalWashoutId = 'adrenal_washout';
  static const String licId = 'lic';

  /// Gets metadata about available variables for a calculator
  ///
  /// Returns information about which Mustache variables are available for
  /// use in templates for a specific calculator.
  ///
  /// **Parameters**
  ///
  /// * `calculatorId` : String - Calculator identifier
  ///
  /// **Returns**
  ///
  /// * `CalculatorMetadata` - Metadata with variable information
  ///
  /// **Example**
  ///
  /// ```dart
  /// final metadata = service.getCalculatorMetadata(SnippetTemplatesService.prostateVolumeId);
  /// print(metadata.availableVariables); // ["diagnosis", "volume", "d1", "d2", "d3"]
  /// ```
  CalculatorMetadata getCalculatorMetadata(String calculatorId) {
    switch (calculatorId) {
      case prostateVolumeId:
        return CalculatorMetadata(
          id: prostateVolumeId,
          name: 'Prostate Volume',
          availableVariables: [
            VariableInfo('diagnosis', 'Size classification (Normal/Prominent/Enlarged)'),
            VariableInfo('volume', 'Rounded volume in ml (integer)'),
            VariableInfo('volumeRaw', 'Raw calculated volume (decimal)'),
            VariableInfo('d1', 'First diameter in cm'),
            VariableInfo('d2', 'Second diameter in cm'),
            VariableInfo('d3', 'Third diameter in cm'),
          ],
          sampleData: {
            'diagnosis': 'Prominent',
            'volume': 29,
            'volumeRaw': 28.649,
            'd1': 4.5,
            'd2': 3.2,
            'd3': 3.8,
          },
        );
      case spineHeightLossId:
        return CalculatorMetadata(
          id: spineHeightLossId,
          name: 'Spine Height Loss',
          availableVariables: [
            VariableInfo('diagnosis', 'Severity classification (Mild/Moderate/Severe)'),
            VariableInfo('lossPercentRounded', 'Rounded loss percentage (integer)'),
            VariableInfo('lossPercent', 'Raw loss percentage (decimal)'),
            VariableInfo('normalMean', 'Mean of normal heights in cm'),
            VariableInfo('collapsedMean', 'Mean of collapsed heights in cm'),
          ],
          sampleData: {
            'diagnosis': 'Moderate',
            'lossPercentRounded': 35,
            'lossPercent': 35.2,
            'normalMean': 2.5,
            'collapsedMean': 1.62,
          },
        );
      case adrenalWashoutId:
        return CalculatorMetadata(
          id: adrenalWashoutId,
          name: 'Adrenal Washout',
          availableVariables: [
            VariableInfo('nc', 'Non-contrast HU value (optional)'),
            VariableInfo('enh', 'Enhanced HU value'),
            VariableInfo('delayed', 'Delayed HU value'),
            VariableInfo('rpw', 'Relative percentage washout (raw decimal)'),
            VariableInfo('apw', 'Absolute percentage washout (raw decimal, null if nc not provided)'),
            VariableInfo('rpwOneDecimal', 'RPW formatted to 1 decimal place'),
            VariableInfo('apwOneDecimal', 'APW formatted to 1 decimal place (null if nc not provided)'),
          ],
          sampleData: {
            'nc': 10.0,
            'enh': 100.0,
            'delayed': 60.0,
            'rpw': 40.0,
            'apw': 44.4,
            'rpwOneDecimal': '40.0',
            'apwOneDecimal': '44.4',
          },
        );
      case licId:
        return CalculatorMetadata(
          id: licId,
          name: 'Liver Iron Concentration (LIC)',
          availableVariables: [
            VariableInfo('t2StarMsLtLobe', 'T2* value of left lobe in ms'),
            VariableInfo('t2StarMsRtAntLobe', 'T2* value of right anterior lobe in ms'),
            VariableInfo('t2StarMsRtPostLobe', 'T2* value of right posterior lobe in ms'),
            VariableInfo('licLtLobe', 'Raw LIC of left lobe (mg Fe/g dry weight)'),
            VariableInfo('licRtAntLobe', 'Raw LIC of right anterior lobe (mg Fe/g dry weight)'),
            VariableInfo('licRtPostLobe', 'Raw LIC of right posterior lobe (mg Fe/g dry weight)'),
            VariableInfo('licLtLobeTwoDecimal', 'LIC left lobe formatted to 2 decimals'),
            VariableInfo('licRtAntLobeTwoDecimal', 'LIC right anterior lobe formatted to 2 decimals'),
            VariableInfo('licRtPostLobeTwoDecimal', 'LIC right posterior lobe formatted to 2 decimals'),
          ],
          sampleData: {
            't2StarMsLtLobe': 15.5,
            't2StarMsRtAntLobe': 14.2,
            't2StarMsRtPostLobe': 16.8,
            'licLtLobe': 1.845,
            'licRtAntLobe': 2.103,
            'licRtPostLobe': 1.672,
            'licLtLobeTwoDecimal': '1.85',
            'licRtAntLobeTwoDecimal': '2.10',
            'licRtPostLobeTwoDecimal': '1.67',
          },
        );
      default:
        throw ArgumentError('Unknown calculator ID: $calculatorId');
    }
  }



  /// Gets the template for a calculator
  ///
  /// Returns the user's custom template if it exists, otherwise returns
  /// the default template from assets.
  ///
  /// **Parameters**
  ///
  /// * `calculatorId` : String - Calculator identifier (use constants above)
  ///
  /// **Returns**
  ///
  /// * `Future<String>` - Template string (Mustache format)
  ///
  /// **Example**
  ///
  /// ```dart
  /// final template = await service.getTemplate(SnippetTemplatesService.prostateVolumeId);
  /// ```
  Future<String> getTemplate(String calculatorId) async {
    try {
      final customTemplate = await _prefs.getString('$_keyPrefix$calculatorId');

      if (customTemplate != null && customTemplate.isNotEmpty) {
        return customTemplate;
      }

      return await _loadDefaultTemplate(calculatorId);
    } catch (e) {
      return await _loadDefaultTemplate(calculatorId);
    }
  }

  /// Saves a custom template for a calculator
  ///
  /// **Parameters**
  ///
  /// * `calculatorId` : String - Calculator identifier
  /// * `template` : String - Mustache template string to save
  ///
  /// **Returns**
  ///
  /// * `Future<void>`
  ///
  /// **Example**
  ///
  /// ```dart
  /// await service.saveTemplate(
  ///   SnippetTemplatesService.prostateVolumeId,
  ///   '{{diagnosis}} prostate: {{volume}}ml'
  /// );
  /// ```
  Future<void> saveTemplate(String calculatorId, String template) async {
    await _prefs.setString('$_keyPrefix$calculatorId', template);
  }

  /// Resets a calculator's template to the default
  ///
  /// Removes the user's custom template, causing future calls to `getTemplate()`
  /// to return the default template.
  ///
  /// **Parameters**
  ///
  /// * `calculatorId` : String - Calculator identifier
  ///
  /// **Returns**
  ///
  /// * `Future<void>`
  ///
  /// **Example**
  ///
  /// ```dart
  /// await service.resetToDefault(SnippetTemplatesService.prostateVolumeId);
  /// ```
  Future<void> resetToDefault(String calculatorId) async {
    await _prefs.remove('$_keyPrefix$calculatorId');
  }

  /// Checks if a calculator has a custom template
  ///
  /// **Parameters**
  ///
  /// * `calculatorId` : String - Calculator identifier
  ///
  /// **Returns**
  ///
  /// * `Future<bool>` - true if user has customized this template
  ///
  /// **Example**
  ///
  /// ```dart
  /// if (await service.hasCustomTemplate(SnippetTemplatesService.prostateVolumeId)) {
  ///   // Show "Reset to Default" button
  /// }
  /// ```
  Future<bool> hasCustomTemplate(String calculatorId) async {
    final customTemplate = await _prefs.getString('$_keyPrefix$calculatorId');
    return customTemplate != null && customTemplate.isNotEmpty;
  }


  /// Gets a list of all calculator IDs
  ///
  /// **Returns**
  ///
  /// * `List<String>` - List of all calculator identifiers
  List<String> getAllCalculatorIds() {
    return [prostateVolumeId, spineHeightLossId, adrenalWashoutId, licId];
  }

  /// Loads the default template from assets
  Future<String> _loadDefaultTemplate(String calculatorId) async {
    try {
      final path = 'lib/services/calculator/templates/$calculatorId.mustache';
      return await rootBundle.loadString(path);
    } catch (e) {
      throw Exception('Failed to load default template for $calculatorId: $e');
    }
  }
}

