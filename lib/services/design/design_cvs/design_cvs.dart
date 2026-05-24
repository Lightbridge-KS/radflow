import 'package:flutter/services.dart' show rootBundle;
import 'package:mustachex/mustachex.dart';
import 'design_cvs_protocol_data.dart';

/// Generates cardiovascular (CTA / MRA) study protocol templates.
///
/// Looks up a protocol by [protocolId] in [DesignCvsProtocolData.protocolInfo]
/// and renders the shared mustache template
/// (`lib/services/design/design_cvs/template/temp_cvs.mustache`).
///
/// Unlike the emergency-radiology [Designer], CVS protocols do not collect
/// patient-side parameters (NPO, eGFR, premedications, etc.) — the rendered
/// output is fully determined by the static protocol data.
///
/// Example:
/// ```dart
/// final cvs = DesignCvs(protocolId: 'cta_coro');
/// final text = await cvs.generate();
/// ```
class DesignCvs {
  /// Protocol identifier; must be a key of
  /// [DesignCvsProtocolData.protocolInfo].
  final String protocolId;

  DesignCvs({
    required this.protocolId,
  });

  /// Renders the protocol template as a single string.
  ///
  /// Throws an [Exception] if [protocolId] is not registered in
  /// [DesignCvsProtocolData.protocolInfo], or if the mustache asset cannot be
  /// loaded (e.g. its directory is not declared in `pubspec.yaml`).
  Future<String> generate() async {
    return await designCvsStudy();
  }

  /// Resolves the protocol entry and renders the CVS mustache template.
  ///
  /// Kept separate from [generate] to leave room for future per-modality
  /// branches (e.g. a dedicated MRA template) without changing callers.
  Future<String> designCvsStudy() async {
    final protocolInfo = DesignCvsProtocolData.protocolInfo[protocolId];
    if (protocolInfo == null) {
      throw Exception('Protocol ID not found: $protocolId');
    }

    final templateString = await rootBundle.loadString(
      'lib/services/design/design_cvs/template/temp_cvs.mustache',
    );
    final template = Template(templateString, htmlEscapeValues: false);

    final data = _prepareCvsData(protocolInfo);
    return template.renderString(data);
  }

  /// Builds the mustache context map from a protocol entry.
  ///
  /// Trims `phaseDesignText`, `contrastText`, and `note` so the triple-quoted
  /// source blocks in [DesignCvsProtocolData] (which start and end with `\n`
  /// for readability) don't introduce blank lines under their section headers
  /// in the rendered output. Missing optional fields stay `null`, which
  /// mustache treats as falsy and omits the surrounding section.
  Map<String, dynamic> _prepareCvsData(Map<String, Object?> protocolInfo) {
    final protocolName = protocolInfo['protocolName'];
    final phaseDesignText = (protocolInfo['phaseDesignText'] as String?)?.trim();
    final contrastText = (protocolInfo['contrastText'] as String?)?.trim();
    final note = (protocolInfo['note'] as String?)?.trim();

    return <String, dynamic>{
      'protocolName': protocolName,
      'phaseDesignText': phaseDesignText,
      'contrastText': contrastText,
      'note': note,
    };
  }
}
