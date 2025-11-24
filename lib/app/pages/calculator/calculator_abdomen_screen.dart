import 'package:flutter/material.dart';
import 'app_prostate_volume_calculator.dart';
import 'app_spine.dart';

class CalculatorAbdomenScreen extends StatelessWidget {
  const CalculatorAbdomenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppProstateVolumeCalculator(),
            SizedBox(height: 32),
            AppSpineCalculator(), 
          ],
        ),
      );
  }
}