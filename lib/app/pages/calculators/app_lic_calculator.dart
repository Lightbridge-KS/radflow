import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../../../core/result.dart';
import '../../../services/calculator/lic_calculator.dart';
import '../../../services/calculator/shared/template_renderer.dart';
import '../../../services/preferences/snippet_templates_service.dart';
import '../../providers/snippet_templates_provider.dart';
import '../../widgets/buttons.dart';
import '../../widgets/citation_url_launcher.dart';
import 'calculator_error_handler.dart';

class AppLicCalculator extends ConsumerStatefulWidget {
  const AppLicCalculator({super.key});

  @override
  ConsumerState<AppLicCalculator> createState() => _AppLicCalculatorState();
}

class _AppLicCalculatorState extends ConsumerState<AppLicCalculator> {
  final TextEditingController _t2StarLtLobeController = TextEditingController();
  final TextEditingController _t2StarRtAntLobeController = TextEditingController();
  final TextEditingController _t2StarRtPostLobeController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();

  @override
  void dispose() {
    _t2StarLtLobeController.dispose();
    _t2StarRtAntLobeController.dispose();
    _t2StarRtPostLobeController.dispose();
    _outputController.dispose();
    super.dispose();
  }

  Future<void> _calculate() async {
    final result = LicCalculator().getLicDataFromString(
      t2StarMsLtLobe: _t2StarLtLobeController.text,
      t2StarMsRtAntLobe: _t2StarRtAntLobeController.text,
      t2StarMsRtPostLobe: _t2StarRtPostLobeController.text,
    );

    switch (result) {
      case Success(value: final data):
        // Get template and render
        final service = ref.read(snippetTemplatesServiceProvider);
        final template = await service.getTemplate(SnippetTemplatesService.licId);

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
      _t2StarLtLobeController.clear();
      _t2StarRtAntLobeController.clear();
      _t2StarRtPostLobeController.clear();
      _outputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Liver Iron Concentration (LIC) Calculator',
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
                    controller: _t2StarLtLobeController,
                    decoration: const InputDecoration(
                      labelText: 'T2* Left Lobe (ms)',
                      hintText: 'e.g. 15.5',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onSubmitted: (_) => _calculate(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _t2StarRtAntLobeController,
                    decoration: const InputDecoration(
                      labelText: 'T2* Right Anterior Lobe (ms)',
                      hintText: 'e.g. 14.2',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onSubmitted: (_) => _calculate(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _t2StarRtPostLobeController,
                    decoration: const InputDecoration(
                      labelText: 'T2* Right Posterior Lobe (ms)',
                      hintText: 'e.g. 16.8',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onSubmitted: (_) => _calculate(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter T2* values in milliseconds from ROI measurements in each hepatic lobe',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Normal LIC: <1.8 mg/g | Borderline: 1.8-3.2 | Mild: 3.2-7.0 | Moderate: 7.0-15.0 mg/g | Severe ≥ 15.0',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Calculation use Modified Garbowski equation:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Math.tex(
                      r'LIC = \frac{31.94}{(T2^*)^{1.014}}',
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Where T2* is in milliseconds and LIC is in mg Fe/g dry weight',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text("References:",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                  ),
                  const SizedBox(height: 8),
                  const CitationUrlLauncher(
                    text: 'Garbowski et al. (2014)',
                    href: 'https://pubmed.ncbi.nlm.nih.gov/24915987/',
                  ),
                  const CitationUrlLauncher(
                    text: 'Reeder et al. (2023)',
                    href: 'https://pubmed.ncbi.nlm.nih.gov/36809220/',
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
                      hintText: 'Liver Iron Concentration Report...',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: false,
                    maxLines: 12
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
