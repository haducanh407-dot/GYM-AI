import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/auth.dart';
import 'screens/camera.dart';
import 'screens/onboarding.dart';
import 'screens/settings.dart';
import 'screens/shell.dart';
import 'ui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: GymColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, this.initialRoute = '/login'});
  final String initialRoute;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'AI GYM',
    debugShowCheckedModeBanner: false,
    theme: gymTheme(),
    initialRoute: initialRoute,
    routes: {
      '/': (_) => const AuthScreen(),
      '/login': (_) => const AuthScreen(),
      '/register': (_) => const AuthScreen(register: true),
      '/forgot': (_) => const AuthScreen(forgot: true),
      '/onboarding': (_) => const OnboardingScreen(),
      '/home': (_) => const AppShell(),
      '/camera': (_) => const CameraScreen(),
      '/settings': (_) => const SettingsScreen(),
      '/coach-settings': (_) => const CoachSettingsScreen(),
    },
    builder: (context, child) => ColoredBox(
      color: const Color(0xFF09090B),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: ClipRect(child: child!),
        ),
      ),
    ),
  );
}
