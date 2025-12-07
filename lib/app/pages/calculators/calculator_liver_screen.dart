import 'package:flutter/material.dart';
import 'app_lic_calculator.dart';


class CalculatorLiverScreen extends StatelessWidget {
  const CalculatorLiverScreen({ super.key });

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppLicCalculator(),
          ],
        ),
      );
  }
}