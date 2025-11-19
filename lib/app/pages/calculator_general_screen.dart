import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class CalculatorGeneralScreen extends StatelessWidget {
  const CalculatorGeneralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('RadFlow - General Calculator')),
      drawer: AppDrawer(),
      body: Center(
        child: Text('Index 2: General Calculator Screen', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}