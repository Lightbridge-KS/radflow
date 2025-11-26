import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/snippet_templates_provider.dart';
import '../../../services/preferences/snippet_templates_service.dart';
import '../../../services/calculator/shared/template_renderer.dart';

/// Full-screen dialog for editing calculator snippet templates
///
/// Allows users to:
/// - Select a calculator from dropdown
/// - Edit the template with Mustache syntax
/// - See available variables
/// - Preview rendered output with sample data
/// - Save custom template or reset to default
class CalculatorTemplateEditorScreen extends ConsumerStatefulWidget {
  const CalculatorTemplateEditorScreen({super.key});

  @override
  ConsumerState<CalculatorTemplateEditorScreen> createState() =>
      _CalculatorTemplateEditorScreenState();
}

class _CalculatorTemplateEditorScreenState
    extends ConsumerState<CalculatorTemplateEditorScreen> {
  late String _selectedCalculatorId;
  final TextEditingController _templateController = TextEditingController();
  String _previewText = '';
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _selectedCalculatorId = SnippetTemplatesService.prostateVolumeId;
    _loadTemplate();
  }

  @override
  void dispose() {
    _templateController.dispose();
    super.dispose();
  }

  /// Loads the template for the selected calculator
  Future<void> _loadTemplate() async {
    final service = ref.read(snippetTemplatesServiceProvider);
    final template = await service.getTemplate(_selectedCalculatorId);

    if (mounted) {
      _templateController.text = template;
      _updatePreview();
    }
  }

  /// Updates the preview with the current template and sample data
  void _updatePreview() {
    final metadata = ref.read(calculatorMetadataProvider(_selectedCalculatorId));

    try {
      final preview = TemplateRenderer.render(
        _templateController.text,
        metadata.sampleData,
      );
      setState(() {
        _previewText = preview;
        _errorText = null;
      });
    } catch (e) {
      setState(() {
        _previewText = '';
        _errorText = 'Template error: ${e.toString()}';
      });
    }
  }

  /// Saves the current template
  Future<void> _saveTemplate() async {
    final service = ref.read(snippetTemplatesServiceProvider);

    // Validate template first
    if (!TemplateRenderer.isValid(_templateController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Template syntax is invalid'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await service.saveTemplate(_selectedCalculatorId, _templateController.text);

    // Invalidate the provider to refresh
    ref.invalidate(templateProvider(_selectedCalculatorId));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Template saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  /// Resets the template to default
  Future<void> _resetToDefault() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Default'),
        content: const Text(
          'This will reset the template to its default value. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final service = ref.read(snippetTemplatesServiceProvider);
      await service.resetToDefault(_selectedCalculatorId);

      // Invalidate the provider to refresh
      ref.invalidate(templateProvider(_selectedCalculatorId));

      // Reload template after reset
      await _loadTemplate();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Template reset to default'),
          ),
        );
      }
    }
  }

  /// Handles calculator selection change
  void _onCalculatorChanged(String? newCalculatorId) {
    if (newCalculatorId != null && newCalculatorId != _selectedCalculatorId) {
      setState(() {
        _selectedCalculatorId = newCalculatorId;
      });
      _loadTemplate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final calculatorIds = ref.watch(allCalculatorIdsProvider);
    final metadata = ref.watch(calculatorMetadataProvider(_selectedCalculatorId));
    final templateAsync = ref.watch(templateProvider(_selectedCalculatorId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator Templates'),
        actions: [
          IconButton(
            onPressed: _resetToDefault,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset to Default',
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: _saveTemplate,
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: templateAsync.when(
        data: (_) => SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Calculator selector
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Text(
                            'Calculator:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButton<String>(
                              value: _selectedCalculatorId,
                              isExpanded: true,
                              onChanged: _onCalculatorChanged,
                              items: calculatorIds.map((id) {
                                final meta = ref.read(calculatorMetadataProvider(id));
                                return DropdownMenuItem(
                                  value: id,
                                  child: Text(meta.name),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Available variables section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Available Variables',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Use these variables in your template with {{variable}} syntax:',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: metadata.availableVariables.map((variable) {
                              return Tooltip(
                                message: variable.description,
                                child: Chip(
                                  label: Text('{{${variable.name}}}'),
                                  labelStyle: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Template editor
                  Text(
                    'Template',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _templateController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Enter Mustache template...',
                      errorText: _errorText,
                      helperText: 'Use {{variable}} for interpolation',
                    ),
                    onChanged: (_) => _updatePreview(),
                  ),
                  const SizedBox(height: 24),

                  // Preview section
                  Text(
                    'Preview (with sample data)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      constraints: const BoxConstraints(minHeight: 100),
                      child: _errorText != null
                          ? Text(
                              _errorText!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            )
                          : Text(
                              _previewText,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sample data display
                  ExpansionTile(
                    title: const Text('View Sample Data'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            metadata.sampleData.entries
                                .map((e) => '${e.key}: ${e.value}')
                                .join('\n'),
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error loading template: $err'),
        ),
      ),
    );
  }
}
