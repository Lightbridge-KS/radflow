import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/result.dart';
import '../../../services/calculator/volume_calculator.dart';
import '../../../services/calculator/shared/template_renderer.dart';
import '../../../services/preferences/snippet_templates_service.dart';
import '../../providers/snippet_templates_provider.dart';
import '../../widgets/buttons.dart';
import 'calculator_error_handler.dart';

class AppProstateVolumeCalculator extends ConsumerStatefulWidget {
  const AppProstateVolumeCalculator({super.key});

  @override
  ConsumerState<AppProstateVolumeCalculator> createState() => _AppProstateVolumeCalculatorState();
}

class _AppProstateVolumeCalculatorState extends ConsumerState<AppProstateVolumeCalculator> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    _outputController.dispose();
    super.dispose();
  }

  Future<void> _calculate() async {
    final result = VolumeCalculator.getProstateVolumeDataFromString(_inputController.text);

    switch (result) {
      case Success(value: final data):
        // Render template
        final service = ref.read(snippetTemplatesServiceProvider);
        final template = await service.getTemplate(SnippetTemplatesService.prostateVolumeId);

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
      _inputController.clear();
      _outputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prostate Volume',
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
                    controller: _inputController,
                    decoration: const InputDecoration(
                      labelText: 'Input: Diameters in 3 planes (cm)',
                      hintText: 'e.g. 4.4 4.5 4.6',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _calculate(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Input perpendicular diameters (cm) in 3 planes, separated by spaces or comma (e.g. 4.4 4.5 4.6)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Normal (<25 ml), Prominent (25-40 ml), Enlarged (>40 ml)',
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
                      labelText: 'Prostate volume snippet',
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