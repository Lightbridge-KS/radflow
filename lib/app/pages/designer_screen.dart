import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';


class DesignERScreen extends StatelessWidget {
  const DesignERScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('RadFlow - Design ER')),
      drawer: AppDrawer(),
      body: Center(
        child: Text('Index 1: Design ER Screen', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}