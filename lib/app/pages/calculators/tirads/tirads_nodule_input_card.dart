import 'package:flutter/material.dart';
import '../../../../services/calculator/tirads_calculator/tirads_calculator.dart';
import '../../../../services/calculator/tirads_calculator/tirads_calculator_data.dart';
import '../../../../services/calculator/tirads_calculator/models/tirads_models.dart';
import '../../../../core/result.dart';

/// State model for a single nodule input card
class TiradsNoduleCardState {
  final int id;
  String location;
  String sizeText;
  String? composition;
  String? echogenicity;
  String? shape;
  String? margin;
  List<String> echogenicFoci;

  // Computed assessment (updated in real-time)
  TiradsNoduleAssessment? assessment;
  String? errorMessage;

  TiradsNoduleCardState({
    required this.id,
    this.location = '',
    this.sizeText = '',
    this.composition,
    this.echogenicity,
    this.shape,
    this.margin,
    List<String>? echogenicFoci,
    this.assessment,
    this.errorMessage,
  }) : echogenicFoci = echogenicFoci ?? [];

  /// Returns true if all required fields are filled
  bool get isComplete =>
      composition != null &&
      echogenicity != null &&
      shape != null &&
      margin != null &&
      echogenicFoci.isNotEmpty;

  /// Creates a copy with updated values
  TiradsNoduleCardState copyWith({
    int? id,
    String? location,
    String? sizeText,
    String? composition,
    String? echogenicity,
    String? shape,
    String? margin,
    List<String>? echogenicFoci,
    TiradsNoduleAssessment? assessment,
    String? errorMessage,
  }) {
    return TiradsNoduleCardState(
      id: id ?? this.id,
      location: location ?? this.location,
      sizeText: sizeText ?? this.sizeText,
      composition: composition ?? this.composition,
      echogenicity: echogenicity ?? this.echogenicity,
      shape: shape ?? this.shape,
      margin: margin ?? this.margin,
      echogenicFoci: echogenicFoci ?? List.from(this.echogenicFoci),
      assessment: assessment,
      errorMessage: errorMessage,
    );
  }

  /// Resets all fields to initial state
  TiradsNoduleCardState reset() {
    return TiradsNoduleCardState(id: id);
  }
}

/// A card widget for inputting a single thyroid nodule's characteristics
class TiradsNoduleInputCard extends StatefulWidget {
  final TiradsNoduleCardState state;
  final bool deletable;
  final ValueChanged<TiradsNoduleCardState> onChanged;
  final VoidCallback? onDelete;

  const TiradsNoduleInputCard({
    super.key,
    required this.state,
    required this.deletable,
    required this.onChanged,
    this.onDelete,
  });

  @override
  State<TiradsNoduleInputCard> createState() => _TiradsNoduleInputCardState();
}

class _TiradsNoduleInputCardState extends State<TiradsNoduleInputCard> {
  late TextEditingController _locationController;
  late TextEditingController _sizeController;

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController(text: widget.state.location);
    _sizeController = TextEditingController(text: widget.state.sizeText);
  }

  @override
  void didUpdateWidget(TiradsNoduleInputCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controllers only if state changed externally (e.g., reset)
    // Don't update if the controller already has the same text (user is typing)
    if (oldWidget.state.location != widget.state.location &&
        _locationController.text != widget.state.location) {
      _locationController.text = widget.state.location;
    }
    if (oldWidget.state.sizeText != widget.state.sizeText &&
        _sizeController.text != widget.state.sizeText) {
      _sizeController.text = widget.state.sizeText;
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  void _updateState(TiradsNoduleCardState newState) {
    // Calculate assessment if all required fields are filled
    if (newState.isComplete) {
      final sizeInCm = double.tryParse(newState.sizeText);
      final result = TiradsCalculator.getTiradsNoduleAssessment(
        id: newState.id,
        location: newState.location.isEmpty ? 'Nodule ${newState.id}' : newState.location,
        composition: newState.composition!,
        echogenicity: newState.echogenicity!,
        shape: newState.shape!,
        margin: newState.margin!,
        echogenicFoci: newState.echogenicFoci,
        sizeInCm: sizeInCm,
      );

      switch (result) {
        case Success(value: final assessment):
          newState = newState.copyWith(
            assessment: assessment,
            errorMessage: null,
          );
        case Failure(error: final err):
          newState = newState.copyWith(
            assessment: null,
            errorMessage: err.message,
          );
      }
    } else {
      newState = newState.copyWith(assessment: null, errorMessage: null);
    }

    widget.onChanged(newState);
  }

  void _onReset() {
    _locationController.clear();
    _sizeController.clear();
    _updateState(widget.state.reset());
  }

  void _toggleEchogenicFoci(String value) {
    final currentFoci = List<String>.from(widget.state.echogenicFoci);

    if (currentFoci.contains(value)) {
      currentFoci.remove(value);
    } else {
      // If selecting "none-comet", clear others
      if (value == 'none-comet') {
        currentFoci.clear();
        currentFoci.add(value);
      } else {
        // If selecting other foci, remove "none-comet"
        currentFoci.remove('none-comet');
        currentFoci.add(value);
      }
    }

    _updateState(widget.state.copyWith(echogenicFoci: currentFoci));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = widget.state;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            _buildHeader(context, state),
            const SizedBox(height: 12),

            // Location and Size Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location TextField
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      hintText: 'e.g., Right lobe, mid',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (value) {
                      _updateState(state.copyWith(location: value));
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Size TextField (optional)
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _sizeController,
                    decoration: const InputDecoration(
                      labelText: 'Size (cm)',
                      hintText: 'Optional',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      _updateState(state.copyWith(sizeText: value));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Dropdown Menus
            _buildDropdownRow('Composition', 'composition', state.composition),
            const SizedBox(height: 8),
            _buildDropdownRow('Echogenicity', 'echogenicity', state.echogenicity),
            const SizedBox(height: 8),
            _buildDropdownRow('Shape', 'shape', state.shape),
            const SizedBox(height: 8),
            _buildDropdownRow('Margin', 'margin', state.margin),
            const SizedBox(height: 16),

            // Echogenic Foci Checkboxes
            Text(
              'Echogenic Foci',
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            _buildEchogenicFociCheckboxes(state),

            // Assessment Preview
            if (state.isComplete) ...[
              const Divider(height: 24),
              _buildAssessmentPreview(context, state),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TiradsNoduleCardState state) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          'Nodule ${state.id}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.refresh, size: 20),
          tooltip: 'Reset',
          onPressed: _onReset,
          visualDensity: VisualDensity.compact,
        ),
        if (widget.deletable)
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            tooltip: 'Delete',
            onPressed: widget.onDelete,
            visualDensity: VisualDensity.compact,
          ),
      ],
    );
  }

  Widget _buildDropdownRow(String label, String category, String? value) {
    final choices = TiradsCalculatorData.tiradsMapUIchoices[category]!;

    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Expanded(
          child: DropdownMenu<String>(
            initialSelection: value,
            expandedInsets: EdgeInsets.zero,
            onSelected: (selected) {
              if (selected != null) {
                final newState = switch (category) {
                  'composition' => widget.state.copyWith(composition: selected),
                  'echogenicity' => widget.state.copyWith(echogenicity: selected),
                  'shape' => widget.state.copyWith(shape: selected),
                  'margin' => widget.state.copyWith(margin: selected),
                  _ => widget.state,
                };
                _updateState(newState);
              }
            },
            dropdownMenuEntries: choices.entries.map((e) {
              return DropdownMenuEntry<String>(
                value: e.key,
                label: e.value,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildEchogenicFociCheckboxes(TiradsNoduleCardState state) {
    final choices = TiradsCalculatorData.tiradsMapUIchoices['echogenic_foci']!;

    return Column(
      children: choices.entries.map((e) {
        final isNoneComet = e.key == 'none-comet';
        final hasOtherFoci = state.echogenicFoci.any((f) => f != 'none-comet');

        return CheckboxListTile(
          title: Text(
            e.value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          value: state.echogenicFoci.contains(e.key),
          dense: true,
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.zero,
          // Disable other options if none-comet is selected
          // Disable none-comet if other foci are selected
          onChanged: (isNoneComet && hasOtherFoci) ||
                     (!isNoneComet && state.echogenicFoci.contains('none-comet'))
              ? null
              : (_) => _toggleEchogenicFoci(e.key),
        );
      }).toList(),
    );
  }

  Widget _buildAssessmentPreview(BuildContext context, TiradsNoduleCardState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (state.errorMessage != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: colorScheme.error, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                state.errorMessage!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final assessment = state.assessment;
    if (assessment == null) return const SizedBox.shrink();

    // Get color based on TR level
    final trColor = switch (assessment.tiradsLevel) {
      'TR1' => Colors.green,
      'TR2' => Colors.lightGreen,
      'TR3' => Colors.yellow.shade700,
      'TR4' => Colors.orange,
      'TR5' => Colors.red,
      _ => colorScheme.primary,
    };

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: trColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: trColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                assessment.tiradsLevel,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: trColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${assessment.pointsTotal} points)',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '- ${assessment.tiradsLevelDesc}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (assessment.recommendation.summary.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Recommendation: ${assessment.recommendation.summary}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ] else if (assessment.recommendation.action == 'Size-dependent') ...[
            const SizedBox(height: 4),
            Text(
              'FNA if ${assessment.recommendation.fnaCutoff}, Follow if ${assessment.recommendation.followCutoff}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
