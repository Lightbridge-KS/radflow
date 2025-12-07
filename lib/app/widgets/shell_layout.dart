import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_drawer.dart';
import '../enums/screen_info.dart';
import '../router.dart';

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
    final titleMap = {
      Routes.home: 'RadFlow',
      Routes.designER: ScreenInfo.designER.title, 
      Routes.calculatorAbdomen: 'Abdomen Calculator',
      Routes.calculatorLiver: "Liver Calculator", 
      Routes.settings: 'Settings',
    };

    return titleMap[path] ?? 'RadFlow';
  }

  @override
  Widget build(BuildContext context) {
    // Get current route path
    final currentPath = GoRouterState.of(context).uri.path;
    final isHomePage = currentPath == '/';
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getTitleForRoute(currentPath),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isHomePage ? Colors.transparent : colorScheme.inversePrimary,
        elevation: isHomePage ? 0 : null,
        flexibleSpace: isHomePage
            ? Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primaryContainer.withValues(alpha: 0.3),
                      colorScheme.primary.withValues(alpha: 0.1),
                    ],
                  ),
                ),
              )
            : null,
      ),
      drawer: const AppDrawer(),
      body: child,
    );
  }
}
