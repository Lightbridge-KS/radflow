import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

// Screen Widgets
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('RadFlow - Home')),
      drawer: AppDrawer(),
      body: Center(
        child: Text('Index 0: Home Screen', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}