import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'services/api_client.dart';
import 'services/auth_service.dart';
import 'screens/auth.dart';
import 'screens/camera.dart';
import 'screens/onboarding.dart';
import 'screens/reset_password.dart';
import 'screens/settings.dart';
import 'screens/shell.dart';
import 'ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.initialize();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: GymColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(MainApp(initialRoute: _initialRoute()));
}

String _initialRoute() {
  final fragment = Uri.base.fragment;
  if (fragment.startsWith('/reset-password')) {
    return fragment;
  }
  return ApiClient.instance.token != null ? '/home' : '/login';
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
    onGenerateRoute: (settings) {
      final route = Uri.parse(settings.name ?? '');
      if (route.path == '/reset-password') {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => ResetPasswordScreen(
            email: route.queryParameters['email'] ?? '',
            token: route.queryParameters['token'] ?? '',
          ),
        );
      }
      return null;
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
