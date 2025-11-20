import 'package:flutter/services.dart' show rootBundle;
import 'package:mustachex/mustachex.dart';
import 'protocol_data.dart';
import '../_utils.dart';

/// A Flutter class for generating CT and MRI protocol templates in emergency departments.
/// 
/// The `Designer` class generates medical imaging protocol templates by combining 
/// protocol data with user-provided parameters using Mustache templating.
/// 
/// **Example usage:**
/// ```dart
/// final designer = Designer(
///   protocolId: 'ct_whole_abd_routine',
///   npoTime: '6 hours',
///   egfrValue: '90',
///   pregnancy: false,
///   hasETT: true,
///   refPhysicianName: 'Dr. Smith',
/// );
/// 
/// final template = await designer.generate();
/// print(template);
/// ```
/// 
/// **Supported Protocol Types:**
/// - CT protocols: Various CT imaging protocols for different body regions and conditions
/// - MRI protocols: Currently supports MRI screening for whole spine
class Designer {
  /// The unique identifier for the protocol to use for template generation.
  /// 
  /// This must match a valid protocol ID from the `ProtocolData.protocolInfo` map.
  /// Examples: 'ct_whole_abd_routine', 'mri_screening_whole_spine', 'cta_pe_no_dvt'
  final String protocolId;
  
  final String? npoTime;
  final String? egfrDate;
  final String? egfrValue;
  final String? renalPremed;
  final String? allergyPremed;
  final bool? pregnancy;
  final bool? hasETT;
  final bool? hasC1;
  final String? hasPrecaution;
  final String? specialInst;
  final String? refPhysicianName;
  final String? refPhysicianTel;
  
  /// Creates a new Designer instance for generating medical imaging protocol templates.
  /// 
  /// **Parameters:**
  /// - [protocolId]: Required protocol identifier from ProtocolData.protocolInfo
  /// - [npoTime]: NPO time before procedure (for IV contrast protocols)
  /// - [egfrDate]: Date of eGFR measurement (defaults to current date)
  /// - [egfrValue]: eGFR value in mL/min/1.73m² (for contrast safety)
  /// - [renalPremed]: Renal protection medications
  /// - [allergyPremed]: Allergy prevention medications
  /// - [pregnancy]: Pregnancy status (for radiation safety)
  /// - [hasETT]: Presence of endotracheal tube
  /// - [hasC1]: C1 vertebra concerns or instability
  /// - [hasPrecaution]: Additional safety precautions
  /// - [specialInst]: Special imaging instructions
  /// - [refPhysicianName]: Referring physician's name
  /// - [refPhysicianTel]: Referring physician's telephone
  /// 
  /// **Example:**
  /// ```dart
  /// final designer = Designer(
  ///   protocolId: 'ct_whole_abd_routine',
  ///   npoTime: '6 hours',
  ///   egfrValue: '85',
  ///   pregnancy: false,
  /// );
  /// ```
  Designer({
    required this.protocolId,
    this.npoTime,
    this.egfrDate,
    this.egfrValue,
    this.renalPremed,
    this.allergyPremed,
    this.pregnancy,
    this.hasETT,
    this.hasC1,
    this.hasPrecaution,
    this.specialInst,
    this.refPhysicianName,
    this.refPhysicianTel,
  });

  /// Generates a formatted protocol template based on the protocol ID and parameters.
  /// 
  /// This is the main public method that orchestrates the template generation process.
  /// It automatically determines whether to generate a CT or MRI protocol based on 
  /// the [protocolId] and calls the appropriate generation method.
  /// 
  /// **Returns:**
  /// A `Future<String>` containing the formatted protocol template ready for use.
  /// 
  /// **Throws:**
  /// - `Exception` if the protocol ID is not found in the protocol data
  /// - `Exception` if template files cannot be loaded
  /// 
  /// **Example:**
  /// ```dart
  /// final designer = Designer(protocolId: 'ct_whole_abd_routine');
  /// final template = await designer.generate();
  /// print(template);
  /// // Output: Formatted CT protocol with exam details, phases, contrast info, etc.
  /// ```
  Future<String> generate() async {
    // Check if it's MRI protocol
    List<String> mriProtocolIds =  ['mri_screening_whole_spine'];

    if (mriProtocolIds.contains(protocolId)) {
      return await designMR();
    } else {
      return await designCT();
    }
  }

  /// Generates a CT protocol template.
  /// 
  /// This method handles the generation of CT (Computed Tomography) protocol templates
  /// by loading the CT mustache template and combining it with protocol data and 
  /// user-provided parameters.
  /// 
  /// **Process:**
  /// 1. Retrieves protocol information from `ProtocolData.protocolInfo['ct']`
  /// 2. Loads the CT mustache template from assets
  /// 3. Prepares template data by combining protocol info with user parameters
  /// 4. Renders the final template using mustache templating
  /// 
  /// **Returns:**
  /// A `Future<String>` containing the formatted CT protocol template.
  /// 
  /// **Throws:**
  /// - `Exception` if the protocol ID is not found in CT protocols
  /// - `Exception` if the CT template file cannot be loaded
  /// 
  /// **Template includes:**
  /// - Exam name and protocol name
  /// - Phase design (imaging phases and timing)
  /// - Contrast information (routes and preparations)
  /// - IV contrast details (NPO time, eGFR, premedications) when applicable
  /// - Patient safety information (pregnancy, ET tube, C1 status)
  /// - Special instructions and precautions
  /// - Referring physician details
  Future<String> designCT() async {
    // Get protocol info from the data structure
    final protocolInfo = ProtocolData.protocolInfo['ct']?[protocolId];
    if (protocolInfo == null) {
      throw Exception('Protocol ID not found: $protocolId');
    }

    // Load the mustache template
    final templateString = await rootBundle.loadString('lib/services/design/designer/template/temp_ct.mustache');
    final template = Template(templateString, htmlEscapeValues: false);

    // Prepare data for template
    final data = _prepareCTData(protocolInfo);
    
    // Render template
    return template.renderString(data);
  }

  /// Generates an MRI protocol template.
  /// 
  /// This method handles the generation of MRI (Magnetic Resonance Imaging) protocol 
  /// templates by loading the MRI mustache template and combining it with protocol 
  /// data and user-provided parameters.
  /// 
  /// **Process:**
  /// 1. Retrieves protocol information from `ProtocolData.protocolInfo['mr']`
  /// 2. Loads the MRI mustache template from assets
  /// 3. Prepares template data by combining protocol info with user parameters
  /// 4. Renders the final template using mustache templating
  /// 
  /// **Returns:**
  /// A `Future<String>` containing the formatted MRI protocol template.
  /// 
  /// **Throws:**
  /// - `Exception` if the protocol ID is not found in MRI protocols
  /// - `Exception` if the MRI template file cannot be loaded
  /// 
  /// **Template includes:**
  /// - Protocol header with detailed imaging instructions
  /// - Patient safety information (ET tube, C1 status)
  /// - Special instructions and precautions
  /// - Referring physician details
  /// - Contrast details (when Gadolinium contrast is used)
  /// 
  /// **Note:**
  /// Currently supports MRI screening protocols, primarily for whole spine imaging.
  Future<String> designMR() async {
    // Get protocol info from the data structure
    final protocolInfo = ProtocolData.protocolInfo['mr']?[protocolId];
    if (protocolInfo == null) {
      throw Exception('Protocol ID not found: $protocolId');
    }

    // Load the mustache template
    final templateString = await rootBundle.loadString('lib/services/design/designer/template/temp_mr.mustache');
    final template = Template(templateString, htmlEscapeValues: false);

    // Prepare data for template
    final data = _prepareMRData(protocolInfo);
    
    // Render template
    return template.renderString(data);
  }

  /// Prepares data for CT protocol template rendering.
  /// 
  /// This private method processes protocol information and user parameters to create
  /// a data map suitable for mustache template rendering. It handles data formatting,
  /// default values, and conditional inclusion of template sections.
  /// 
  /// **Parameters:**
  /// - [protocolInfo]: Protocol data from `ProtocolData.protocolInfo['ct'][protocolId]`
  /// 
  /// **Returns:**
  /// A `Map<String, dynamic>` containing all template variables and their values.
  /// 
  /// **Data Processing:**
  /// - Extracts exam name, protocol name, phase design, and contrast information
  /// - Applies formatting using utility functions (`dashIfBlank`, `boolYesDash`)
  /// - Handles conditional sections (IV contrast details only when required)
  /// - Sets default values (current date for eGFR date, dashes for empty fields)
  /// 
  /// **Template Variables:**
  /// - `examName`: Name of the examination
  /// - `protocolName`: Specific protocol name
  /// - `phaseDesignText`: Imaging phases and timing details
  /// - `contrastText`: Contrast routes and preparations
  /// - `useIVcontrast`: Boolean flag for IV contrast sections
  /// - `npoTime`, `egfrDate`, `egfrValue`: Contrast safety parameters
  /// - `renalPremed`, `allergyPremed`: Premedication details
  /// - `pregnancy`: Pregnancy status for radiation safety
  /// - `hasETT`, `hasC1`: Patient positioning and safety flags
  /// - `hasPrecaution`, `specialInst`: Additional instructions
  /// - `refPhysicianName`, `refPhysicianTel`: Referring physician info
  Map<String, dynamic> _prepareCTData(Map<String, Object> protocolInfo) {
    // Extract protocol information
    final examName = protocolInfo['examName'] as String?;
    final protocolName = protocolInfo['protocolName'];
    final phaseDesignText = protocolInfo['phaseDesignText'];
    final contrastText = protocolInfo['contrastText'] as String?;

    // Check if IV contrast is used from protocol data
    final useIVContrast = protocolInfo['useIVcontrast'] as bool? ?? false;

    // Get parameters with defaults from instance fields
    final npoTimeValue = dashIfBlank(npoTime ?? '');
    final egfrValueValue = dashIfBlank(egfrValue ?? '');
    final egfrDateValue = egfrDate ?? getCurrentDate();
    final renalPremedValue = dashIfBlank(renalPremed ?? '');
    final allergyPremedValue = dashIfBlank(allergyPremed ?? '');
    final pregnancyValue = boolYesDash(pregnancy ?? false);
    final hasETTValue = boolYesDash(hasETT ?? false);
    final hasC1Value = boolYesDash(hasC1 ?? false);
    final hasPrecautionValue = dashIfBlank(hasPrecaution ?? '');
    final specialInstValue = dashIfBlank(specialInst ?? '');
    final refPhysicianNameValue = dashIfBlank(refPhysicianName ?? '');
    final refPhysicianTelValue = dashIfBlank(refPhysicianTel ?? '');

    // Build data map for mustache
    final data = <String, dynamic>{
      'hasETT': hasETTValue,
      'hasC1': hasC1Value,
      'hasPrecaution': hasPrecautionValue,
      'specialInst': specialInstValue,
      'refPhysicianName': refPhysicianNameValue,
      'refPhysicianTel': refPhysicianTelValue,
    };

    // Add optional fields if they exist
    data['examName'] = examName;
    data['protocolName'] = protocolName;

    if (phaseDesignText is String) {
      data['phaseDesignText'] = phaseDesignText.trim();
    } else {
      data['phaseDesignText'] = phaseDesignText;
    }
    data['contrastText'] = contrastText;

    if (useIVContrast) {
      data['useIVcontrast'] = true;
      data['npoTime'] = npoTimeValue;
      data['egfrDate'] = egfrDateValue;
      data['egfrValue'] = egfrValueValue;
      data['renalPremed'] = renalPremedValue;
      data['allergyPremed'] = allergyPremedValue;
      data['pregnancy'] = pregnancyValue;
    } else {
      data['useIVcontrast'] = false;
    }

    return data;
  }

  /// Prepares data for MRI protocol template rendering.
  /// 
  /// This private method processes MRI protocol information and user parameters to 
  /// create a data map suitable for mustache template rendering. It handles MRI-specific
  /// data formatting and conditional inclusion of contrast-related sections.
  /// 
  /// **Parameters:**
  /// - [protocolInfo]: Protocol data from `ProtocolData.protocolInfo['mr'][protocolId]`
  /// 
  /// **Returns:**
  /// A `Map<String, dynamic>` containing all MRI template variables and their values.
  /// 
  /// **Data Processing:**
  /// - Extracts protocol header with detailed MRI imaging instructions
  /// - Applies formatting using utility functions (`dashIfBlank`, `boolYesDash`)
  /// - Handles Gadolinium contrast sections when applicable
  /// - Sets default values for missing parameters
  /// 
  /// **Template Variables:**
  /// - `header`: Detailed MRI protocol instructions and sequences
  /// - `hasETT`, `hasC1`: Patient positioning and safety flags
  /// - `hasPrecaution`, `specialInst`: Additional instructions and precautions
  /// - `refPhysicianName`, `refPhysicianTel`: Referring physician information
  /// - `useIVcontrast`: Boolean flag for Gadolinium contrast sections (when used)
  /// - Contrast safety parameters (when Gd contrast is required)
  /// 
  /// **Note:**
  /// MRI protocols typically have more detailed imaging sequences and positioning
  /// instructions compared to CT protocols, reflected in the comprehensive header section.
  Map<String, dynamic> _prepareMRData(Map<String, Object> protocolInfo) {
    // Extract protocol information
    final header = protocolInfo['header'] as String?;

    // Check if IV contrast is used from protocol data (for MRI it's Gd contrast)
    final useIVContrast = protocolInfo['useIVcontrast'] as bool? ?? false;

    // Get parameters with defaults from instance fields
    final npoTimeValue = dashIfBlank(npoTime ?? '');
    final egfrValueValue = dashIfBlank(egfrValue ?? '');
    final egfrDateValue = egfrDate ?? getCurrentDate();
    final renalPremedValue = dashIfBlank(renalPremed ?? '');
    final allergyPremedValue = dashIfBlank(allergyPremed ?? '');
    final pregnancyValue = boolYesDash(pregnancy ?? false);
    final hasETTValue = boolYesDash(hasETT ?? false);
    final hasC1Value = boolYesDash(hasC1 ?? false);
    final hasPrecautionValue = dashIfBlank(hasPrecaution ?? '');
    final specialInstValue = dashIfBlank(specialInst ?? '');
    final refPhysicianNameValue = dashIfBlank(refPhysicianName ?? '');
    final refPhysicianTelValue = dashIfBlank(refPhysicianTel ?? '');

    // Build data map for mustache
    final data = <String, dynamic>{
      'header': header ?? '',
      'hasETT': hasETTValue,
      'hasC1': hasC1Value,
      'hasPrecaution': hasPrecautionValue,
      'specialInst': specialInstValue,
      'refPhysicianName': refPhysicianNameValue,
      'refPhysicianTel': refPhysicianTelValue,
    };

    // Add contrast-related fields if IV contrast is used
    if (useIVContrast) {
      data['useIVcontrast'] = true;
      data['npoTime'] = npoTimeValue;
      data['egfrDate'] = egfrDateValue;
      data['egfrValue'] = egfrValueValue;
      data['renalPremed'] = renalPremedValue;
      data['allergyPremed'] = allergyPremedValue;
      data['pregnancy'] = pregnancyValue;
    }

    return data;
  }
}