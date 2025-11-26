import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/result.dart';
import '../../../services/calculator/spine_calculator.dart';
import '../../../services/calculator/shared/template_renderer.dart';
import '../../../services/preferences/snippet_templates_service.dart';
import '../../providers/snippet_templates_provider.dart';
import '../../widgets/buttons.dart';
import 'calculator_error_handler.dart';

class AppSpineCalculator extends ConsumerStatefulWidget {
  const AppSpineCalculator({super.key});

  @override
  ConsumerState<AppSpineCalculator> createState() => _AppSpineCalculatorState();
}

class _AppSpineCalculatorState extends ConsumerState<AppSpineCalculator> {
  final TextEditingController _normalController = TextEditingController();
  final TextEditingController _collapsedController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();

  @override
  void dispose() {
    _normalController.dispose();
    _collapsedController.dispose();
    _outputController.dispose();
    super.dispose();
  }

  Future<void> _calculate() async {
    final result = SpineCalculator.getSpineHeightLossDataFromString(
      normalCm: _normalController.text,
      collapsedCM: _collapsedController.text,
    );

    switch (result) {
      case Success(value: final data):
        // Render template
        final service = ref.read(snippetTemplatesServiceProvider);
        final template = await service.getTemplate(SnippetTemplatesService.spineHeightLossId);

        if (!mounted) return;

        try {
          final output = TemplateRenderer.render(template, data);
          setState(() => _outputController.text = output);
        } catch (e) {
          setState(() => _outputController.text = 'Template error: $e');
          if (mounted) {
            CalculatorErrorHandler.showTemplateError(context);
          }
        }

      case Failure(error: final err):
        setState(() => _outputController.text = '');
        if (mounted) {
          CalculatorErrorHandler.showCalculatorError(context, err);
        }
    }
  }

  void _resetInputs() {
    setState(() {
      _normalController.clear();
      _collapsedController.clear();
      _outputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Spine Height Loss',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _normalController,
                    decoration: const InputDecoration(
                      labelText: 'Input: Normal height (cm)',
                      hintText: 'Normal height in cm',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _calculate(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _collapsedController,
                    decoration: const InputDecoration(
                      labelText: 'Input: Collapsed height (cm)',
                      hintText: 'Collapsed height in cm',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _calculate(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Input height in centimeter and use two values to calculate mean height, separated by spaces or comma (e.g. 10 12)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Mild (20-25%), Moderate (25-40%), Severe (>40%)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _outputController,
                    decoration: const InputDecoration(
                      labelText: 'Height loss snippet',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: false,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GenerateButton(onPressed: _calculate),
                          const SizedBox(width: 8),
                          CopyButton(controller: _outputController),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: _resetInputs,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}