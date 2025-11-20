import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/router.dart';
import 'app/providers/theme_provider.dart';
import 'app/themes/theme_blue.dart';

// Conditional imports - only import window_manager on non-web platforms
import 'app/window_manager_stub.dart' if (dart.library.io) 'package:window_manager/window_manager.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized(); 
  
  // Only configure window manager for desktop platforms
  if (!kIsWeb) {
    await initializeWindow();
  }
  runApp(
      const ProviderScope(
        child: MainApp(),
      ),
    );
}


class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    // Get default text theme and create MaterialTheme instance
    final textTheme = Theme.of(context).textTheme;
    final materialTheme = MaterialTheme(textTheme);

    return MaterialApp.router(
      title: 'RadFlow',
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      themeMode: themeMode,
      routerConfig: AppRouter.router,
    );
  }
}



// Window initialization function that only runs on desktop
Future<void> initializeWindow() async {
  if (!kIsWeb) {
    await windowManager.ensureInitialized(); 

    WindowOptions windowOptions = const WindowOptions(
      size: Size(840, 840), // Set your desired initial size
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.setMinimumSize(Size(840, 840));
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
}