import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/result.dart';
import '../../../services/calculator/adrenal_washout_calculator.dart';
import '../../../services/calculator/shared/template_renderer.dart';
import '../../../services/preferences/snippet_templates_service.dart';
import '../../providers/snippet_templates_provider.dart';
import '../../widgets/buttons.dart';
import 'calculator_error_handler.dart';

class AppAdrenalWashoutCalculator extends ConsumerStatefulWidget {
  const AppAdrenalWashoutCalculator({super.key});

  @override
  ConsumerState<AppAdrenalWashoutCalculator> createState() => _AppAdrenalWashoutCalculatorState();
}

class _AppAdrenalWashoutCalculatorState extends ConsumerState<AppAdrenalWashoutCalculator> {
  final TextEditingController _preContrastController = TextEditingController();
  final TextEditingController _enhancedController = TextEditingController();
  final TextEditingController _delayedController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();

  @override
  void dispose() {
    _preContrastController.dispose();
    _enhancedController.dispose();
    _delayedController.dispose();
    _outputController.dispose();
    super.dispose();
  }

  Future<void> _calculate() async {
    final result = AdrenalWashoutCalculator.getAdrenalWashoutDataFromString(
      nc: _preContrastController.text.trim().isEmpty ? null : _preContrastController.text,
      enh: _enhancedController.text,
      delayed: _delayedController.text,
    );

    switch (result) {
      case Success(value: final data):
        // Get template and render
        final service = ref.read(snippetTemplatesServiceProvider);
        final template = await service.getTemplate(SnippetTemplatesService.adrenalWashoutId);

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
      _preContrastController.clear();
      _enhancedController.clear();
      _delayedController.clear();
      _outputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Adrenal CT Washout Calculator',
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
                    controller: _preContrastController,
                    decoration: const InputDecoration(
                      labelText: 'Pre-contrast (HU) (Optional)',
                      hintText: 'e.g. 10',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onSubmitted: (_) => _calculate(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _enhancedController,
                    decoration: const InputDecoration(
                      labelText: 'Enhanced (HU)',
                      hintText: 'e.g. 100',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onSubmitted: (_) => _calculate(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _delayedController,
                    decoration: const InputDecoration(
                      labelText: '15 Minute Delayed (HU)',
                      hintText: 'e.g. 60',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onSubmitted: (_) => _calculate(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pre-contrast is optional. If provided, both APW and RPW will be calculated.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'APW >60% or RPW >40% suggests adenoma over malignancy',
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
                      labelText: 'Washout Result',
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
