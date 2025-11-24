import 'package:flutter/material.dart';
import '../../../services/calculator/spine_calculator.dart';
import '../../widgets/buttons.dart';

class AppSpineCalculator extends StatefulWidget {
  const AppSpineCalculator({super.key});

  @override
  State<AppSpineCalculator> createState() => _AppSpineCalculatorState();
}

class _AppSpineCalculatorState extends State<AppSpineCalculator> {
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

  void _calculate() {
    final result = SpineCalculator.spineHeightLossFromString(
      normalCm: _normalController.text,
      collapsedCM: _collapsedController.text,
    );
    setState(() {
      _outputController.text = result;
    });
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