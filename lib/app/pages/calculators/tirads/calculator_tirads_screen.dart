import 'package:flutter/material.dart';
import 'app_tirads_calculator.dart';

/// Screen container for the TI-RADS Calculator
class CalculatorTiradsScreen extends StatelessWidget {
  const CalculatorTiradsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: AppTiradsCalculator(),
    );
  }
}
