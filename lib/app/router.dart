import 'package:go_router/go_router.dart';
import 'pages/home_screen.dart';
import 'pages/settings_screen.dart';
import 'pages/designer_screen.dart';
import 'pages/calculator_general_screen.dart';


final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.home,
    routes: [
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: Routes.designER,
        builder: (context, state) => const DesignERScreen(),
      ),
      GoRoute(
        path: Routes.calculatorGeneral,
        builder: (context, state) => const CalculatorGeneralScreen(),
      ),
      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const SettingsScreen(),
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