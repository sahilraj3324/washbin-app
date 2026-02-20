import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:application/services/auth_service.dart';
import 'package:application/app/onboarding-screen/onboarding_screen.dart';
import 'package:application/app/main_nav.dart';
import 'package:application/app/onboarding-screen/user_onboarding_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthService())],
      child: MaterialApp(
        title: 'Washbin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: const _AuthGate(),
      ),
    );
  }
}

/// Determines the initial screen based on auth status.
class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    // Defer until after the first frame so notifyListeners()
    // inside checkAuthStatus() doesn't fire during build.
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAuth());
  }

  Future<void> _checkAuth() async {
    final authService = context.read<AuthService>();
    await authService.checkAuthStatus();
    if (mounted) {
      setState(() {
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Colors.cyan)),
      );
    }

    return Consumer<AuthService>(
      builder: (context, authService, _) {
        if (!authService.isAuthenticated) {
          return const OnboardingScreen();
        }

        final user = authService.user;
        if (user != null && !user.hasCompletedProfile) {
          return const UserOnboardingScreen();
        }

        return const MainNav();
      },
    );
  }
}
