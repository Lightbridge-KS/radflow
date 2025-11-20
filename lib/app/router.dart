import 'package:go_router/go_router.dart';
import 'pages/home_screen.dart';
import 'pages/settings_screen.dart';
import 'pages/designer_screen.dart';
import 'pages/calculator_general_screen.dart';
import 'widgets/shell_layout.dart';

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
            path: Routes.calculatorGeneral,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const CalculatorGeneralScreen(),
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

// Route constants
abstract class Routes {
  static const String home = '/';
  static const String designER = '/design/er';
  static const String calculatorGeneral = '/calc/general';
  static const String settings = '/settings';
}