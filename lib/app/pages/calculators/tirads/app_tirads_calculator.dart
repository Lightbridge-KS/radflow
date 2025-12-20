import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tirads_nodule_input_card.dart';
import '../../../../services/calculator/tirads_calculator/tirads_calculator.dart';
import '../../../../services/calculator/shared/template_renderer.dart';
import '../../../../services/preferences/snippet_templates_service.dart';
import '../../../../core/result.dart';
import '../calculator_error_handler.dart';
import '../../../widgets/buttons.dart';
import '../../../providers/snippet_templates_provider.dart';

/// TI-RADS Calculator Widget
///
/// A two-column layout with nodule input cards on the left and
/// the generated report on the right.
class AppTiradsCalculator extends ConsumerStatefulWidget {
  const AppTiradsCalculator({super.key});

  @override
  ConsumerState<AppTiradsCalculator> createState() => _AppTiradsCalculatorState();
}

class _AppTiradsCalculatorState extends ConsumerState<AppTiradsCalculator> {
  final List<TiradsNoduleCardState> _nodules = [];
  final TextEditingController _outputController = TextEditingController();
  int _nextId = 1;

  @override
  void initState() {
    super.initState();
    _addNodule(); // Start with one nodule
  }

  @override
  void dispose() {
    _outputController.dispose();
    super.dispose();
  }

  void _addNodule() {
    setState(() {
      _nodules.add(TiradsNoduleCardState(id: _nextId++));
    });
  }

  void _removeNodule(int id) {
    if (_nodules.length > 1) {
      setState(() {
        _nodules.removeWhere((n) => n.id == id);
      });
    }
  }

  void _updateNodule(TiradsNoduleCardState updatedState) {
    setState(() {
      final index = _nodules.indexWhere((n) => n.id == updatedState.id);
      if (index != -1) {
        _nodules[index] = updatedState;
      }
    });
  }

  void _resetAll() {
    setState(() {
      _nodules.clear();
      _nextId = 1;
      _addNodule();
      _outputController.clear();
    });
  }

  Future<void> _generate() async {
    // Check if at least one nodule is complete
    final completeNodules = _nodules.where((n) => n.isComplete).toList();
    if (completeNodules.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please complete at least one nodule assessment'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    // Build TiradsNoduleInput list from complete card states
    final noduleInputs = completeNodules.map((state) {
      final sizeInCm = double.tryParse(state.sizeText);
      return (
        id: state.id,
        location: state.location.isEmpty ? 'Nodule ${state.id}' : state.location,
        composition: state.composition!,
        echogenicity: state.echogenicity!,
        shape: state.shape!,
        margin: state.margin!,
        echogenicFoci: state.echogenicFoci,
        sizeInCm: sizeInCm,
      );
    }).toList();

    // Call calculator
    final result = TiradsCalculator.getTiradsOverallAssessment(
      nodules: noduleInputs,
    );

    switch (result) {
      case Success(value: final assessment):
        // Get template
        final service = ref.read(snippetTemplatesServiceProvider);
        final template = await service.getTemplate(SnippetTemplatesService.tiradsId);

        if (!mounted) return;

        // Convert to template data and render
        try {
          final templateData = TiradsCalculator.overallToTemplateData(assessment);
          final output = TemplateRenderer.render(template, templateData);
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'TI-RADS Calculator',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Two-column layout
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column - Input Cards
              Expanded(
                flex: 1,
                child: _buildInputColumn(context),
              ),

              const SizedBox(width: 16),

              // Right Column - Output
              Expanded(
                flex: 1,
                child: _buildOutputColumn(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputColumn(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Nodule cards
          ..._nodules.asMap().entries.map((entry) {
            final index = entry.key;
            final nodule = entry.value;
            final isFirstCard = index == 0;

            return TiradsNoduleInputCard(
              key: ValueKey(nodule.id),
              state: nodule,
              deletable: !isFirstCard,
              onChanged: _updateNodule,
              onDelete: isFirstCard ? null : () => _removeNodule(nodule.id),
            );
          }),

          // Add Nodule Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: FilledButton.tonalIcon(
              onPressed: _addNodule,
              icon: const Icon(Icons.add),
              label: const Text('Add Nodule'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutputColumn(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Output TextField
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _outputController,
              maxLines: 23,
              decoration: InputDecoration(
                hintText: 'TI-RADS Report...',
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colorScheme.tertiary),
                ),
              ),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Action Buttons
        Row(
          children: [
            GenerateButton(onPressed: _generate),
            const SizedBox(width: 8),
            CopyButton(controller: _outputController),
            const Spacer(),
            FilledButton.tonalIcon(
              onPressed: _resetAll,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset All'),
            ),
          ],
        ),
      ],
    );
  }
}
