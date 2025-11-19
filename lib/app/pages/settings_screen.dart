import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('RadFlow - Settings')),
      drawer: AppDrawer(),
      body: Center(
        child: Text('Index 3: Setting Screen', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
