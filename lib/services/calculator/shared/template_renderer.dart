import 'package:mustachex/mustachex.dart';

/// Service for rendering calculator output templates using Mustache syntax
///
/// This class provides template rendering capabilities for calculator snippets,
/// allowing users to customize output formats while maintaining variable interpolation.
///
/// **Example**
///
/// ```dart
/// final template = "{{diagnosis}} prostate, measuring {{volume}} ml.";
/// final variables = {"diagnosis": "Normal", "volume": 20};
/// final result = TemplateRenderer.render(template, variables);
/// // Returns: "Normal prostate, measuring 20 ml."
/// ```
class TemplateRenderer {
  /// Renders a Mustache template with provided variables
  ///
  /// **Parameters**
  ///
  /// * `template` : String - Mustache template string with {{variable}} placeholders
  /// * `variables` : `Map<String, dynamic>` - Data to interpolate into the template
  ///
  /// **Returns**
  ///
  /// * `String` - Rendered template with variables replaced
  ///
  /// **Throws**
  ///
  /// * `TemplateException` if template syntax is invalid
  ///
  /// **Examples**
  ///
  /// ```dart
  /// // Basic usage
  /// render("Value: {{value}}", {"value": 42});
  /// // Returns: "Value: 42"
  ///
  /// // Conditional sections
  /// render("{{#isHigh}}High value{{/isHigh}}", {"isHigh": true});
  /// // Returns: "High value"
  ///
  /// // Missing variables render as empty
  /// render("{{missing}}", {});
  /// // Returns: ""
  /// ```
  static String render(String template, Map<String, dynamic> variables) {
    try {
      final mustache = Template(template, htmlEscapeValues: false);
      return mustache.renderString(variables);
    } catch (e) {
      throw TemplateException('Failed to render template: $e');
    }
  }

  /// Validates if a template string is syntactically correct
  ///
  /// **Parameters**
  ///
  /// * `template` : String - Mustache template to validate
  ///
  /// **Returns**
  ///
  /// * `bool` - true if template is valid, false otherwise
  ///
  /// **Example**
  ///
  /// ```dart
  /// isValid("{{name}}");  // Returns: true
  /// isValid("{{name");    // Returns: false (unclosed tag)
  /// ```
  static bool isValid(String template) {
    try {
      Template(template, htmlEscapeValues: false);
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Exception thrown when template rendering fails
class TemplateException implements Exception {
  final String message;

  TemplateException(this.message);

  @override
  String toString() => 'TemplateException: $message';
}
