import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/job_repository.dart';
import 'data/repositories/profile_repository.dart';
import 'data/services/api_service.dart';
import 'data/services/database_service.dart';
import 'providers/auth_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/saved_jobs_provider.dart';
import 'providers/search_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/saved/saved_screen.dart';
import 'screens/search/search_screen.dart';
import 'shared/widgets/aurora_background.dart';
import 'shared/widgets/bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  final db = DatabaseService.instance;
  final api = ApiService();
  final jobRepo = JobRepository(api, db);
  final profileRepo = ProfileRepository(db);
  final authRepo = AuthRepository(db);

  final authProvider = AuthProvider(authRepo);
  await authProvider.initialize(); // restore session before first frame

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => SearchProvider(jobRepo)),
        ChangeNotifierProvider(create: (_) => SavedJobsProvider(db)..loadAll()),
        ChangeNotifierProvider(
            create: (_) => ProfileProvider(profileRepo)..load()),
      ],
      child: const JobFinderApp(),
    ),
  );

  // Warm-up ping
  Future.microtask(() async {
    final profile = await profileRepo.load();
    if (!profile.isEmpty) {
      api.warmUp(SearchParams.fromProfile(profile));
    }
  });
}

class JobFinderApp extends StatelessWidget {
  const JobFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JobFinder',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: const _AuthGate(),
    );
  }
}

/// Shows LoginScreen until authenticated, then switches to AppShell.
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final status = context.watch<AuthProvider>().status;

    if (status == AuthStatus.unknown) {
      // Splash — aurora background while session is being restored
      return const Scaffold(
        body: AuroraBackground(),
      );
    }

    if (status == AuthStatus.unauthenticated) {
      return const LoginScreen();
    }

    return const _AppShell();
  }
}

class _AppShell extends StatefulWidget {
  const _AppShell();

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> {
  int _currentIndex = 0;

  static const _screens = [
    SearchScreen(),
    SavedScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: AuroraBackground()),
        Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: AppBottomNavBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
          ),
        ),
      ],
    );
  }
}
