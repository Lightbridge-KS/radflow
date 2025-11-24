import 'package:go_router/go_router.dart';
import 'pages/home_screen.dart';
import 'pages/settings_screen.dart';
import 'pages/designer/designer_screen.dart';
import 'pages/calculator/calculator_abdomen_screen.dart';
import 'widgets/shell_layout.dart';

// Route constants
abstract class Routes {
  static const String home = '/';
  static const String designER = '/design/er';
  static const String calculatorAbdomen = '/calc/abdomen';
  static const String settings = '/settings';
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
    ],
  );
}

