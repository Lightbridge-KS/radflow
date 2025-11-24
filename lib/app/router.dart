import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'pages/home_screen.dart';
import 'pages/settings_screen.dart';
import 'pages/designer/designer_screen.dart';
import 'pages/calculators/calculator_abdomen_screen.dart';
import 'pages/settings/calculator_template_editor_screen.dart';
import 'widgets/shell_layout.dart';

// Route constants
abstract class Routes {
  static const String home = '/';
  static const String designER = '/design/er';
  static const String calculatorAbdomen = '/calc/abdomen';
  static const String settings = '/settings';
  static const String calculatorTemplates = '/settings/templates/calc';
}

// Routers
final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.home,
    routes: [
      ShellRoute(
        builder: (context, state, child) => ShellLayout(child: child),
        routes: [
          GoRoute(
            path: Routes.home,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: Routes.designER,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const DesignERScreen(),
            ),
          ),
          GoRoute(
            path: Routes.calculatorAbdomen,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const CalculatorAbdomenScreen(),
            ),
          ),
          GoRoute(
            path: Routes.settings,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SettingsScreen(),
            ),
          ),
        ],
      ),
      // Full-screen dialog route for calculator template editor (outside ShellRoute)
      GoRoute(
        path: Routes.calculatorTemplates,
      pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: const CalculatorTemplateEditorScreen(),
        ),
      ),
    ],
  );
}

