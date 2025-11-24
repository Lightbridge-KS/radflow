import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/preferences/snippet_templates_service.dart';

/// Provider for the SnippetTemplatesService singleton
final snippetTemplatesServiceProvider = Provider<SnippetTemplatesService>((ref) {
  return SnippetTemplatesService();
});

/// Provider for a specific calculator's template
///
/// Returns AsyncValue with the current template for a calculator.
/// Automatically loads from preferences and provides reactive updates.
///
/// **Usage**
///
/// ```dart
/// // In a widget
/// final templateAsync = ref.watch(templateProvider(SnippetTemplatesService.prostateVolumeId));
///
/// templateAsync.when(
///   data: (template) => Text(template),
///   loading: () => CircularProgressIndicator(),
///   error: (err, stack) => Text('Error: $err'),
/// );
/// ```
final templateProvider = FutureProvider.family<String, String>((ref, calculatorId) async {
  final service = ref.read(snippetTemplatesServiceProvider);
  return await service.getTemplate(calculatorId);
});

/// Provider for checking if a calculator has a custom template
///
/// **Usage**
///
/// ```dart
/// final hasCustom = ref.watch(hasCustomTemplateProvider(calculatorId));
///
/// hasCustom.when(
///   data: (isCustom) => isCustom ? Text('Custom') : Text('Default'),
///   loading: () => CircularProgressIndicator(),
///   error: (err, stack) => Text('Error'),
/// );
/// ```
final hasCustomTemplateProvider = FutureProvider.family<bool, String>((ref, calculatorId) async {
  final service = ref.read(snippetTemplatesServiceProvider);
  return await service.hasCustomTemplate(calculatorId);
});

/// Provider for calculator metadata
///
/// Returns metadata including available variables and sample data for a calculator.
///
/// **Usage**
///
/// ```dart
/// final metadata = ref.watch(calculatorMetadataProvider(calculatorId));
/// for (var variable in metadata.availableVariables) {
///   print('{{${variable.name}}} - ${variable.description}');
/// }
/// ```
final calculatorMetadataProvider = Provider.family<CalculatorMetadata, String>((ref, calculatorId) {
  final service = ref.read(snippetTemplatesServiceProvider);
  return service.getCalculatorMetadata(calculatorId);
});

/// Provider for list of all calculator IDs
///
/// **Usage**
///
/// ```dart
/// final calculatorIds = ref.watch(allCalculatorIdsProvider);
/// for (var id in calculatorIds) {
///   // Build UI for each calculator
/// }
/// ```
final allCalculatorIdsProvider = Provider<List<String>>((ref) {
  final service = ref.read(snippetTemplatesServiceProvider);
  return service.getAllCalculatorIds();
});
