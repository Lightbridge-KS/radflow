import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_drawer.dart';

/// Shell layout that provides persistent AppBar and Drawer
/// with dynamic title based on current route
class ShellLayout extends StatelessWidget {
  final Widget child;

  const ShellLayout({
    super.key,
    required this.child,
  });

  /// Map route paths to AppBar titles
  String _getTitleForRoute(String path) {
    const titleMap = {
      '/': 'RadFlow',
      '/design/er': 'Design Study ER',
      '/calc/general': 'General Calculator',
      '/settings': 'Settings',
    };

    return titleMap[path] ?? 'RadFlow';
  }

  @override
  Widget build(BuildContext context) {
    // Get current route path
    final currentPath = GoRouterState.of(context).uri.path;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitleForRoute(currentPath), style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const AppDrawer(),
      body: child,
    );
  }
}
