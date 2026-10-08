import 'package:flutter/material.dart';
import 'models/app_state.dart';
import 'screens/home_screen.dart';
import 'services/storage_service.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StreakApp());
}

class StreakApp extends StatefulWidget {
  const StreakApp({super.key});

  @override
  State<StreakApp> createState() => _StreakAppState();
}

class _StreakAppState extends State<StreakApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Streak Flame',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFFBF7),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: AppLoader(
        isDarkMode: _isDarkMode,
        onToggleTheme: () => setState(() => _isDarkMode = !_isDarkMode),
      ),
    );
  }
}

class AppLoader extends StatefulWidget {
  const AppLoader({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  final StorageService _storage = StorageService();
  AppState? _state;
  bool _splashComplete = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _splashComplete = true);
    });
    _load();
  }

  Future<void> _load() async {
    final state = await _storage.load();
    final last = state.lastCompletionDate;
    if (last != null && !state.completedToday) {
      final today = DateTime.now();
      final lastDay = DateTime(last.year, last.month, last.day);
      final todayDay = DateTime(today.year, today.month, today.day);
      final difference = todayDay.difference(lastDay).inDays;
      if (difference > 1) {
        state.streak = 0;
        await _storage.save(state);
      }
    }
    if (mounted) setState(() => _state = state);
  }

  @override
  Widget build(BuildContext context) {
    if (!_splashComplete) return const SplashScreen();
    if (_state == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return HomeScreen(
      state: _state!,
      storage: _storage,
      isDarkMode: widget.isDarkMode,
      onToggleTheme: widget.onToggleTheme,
    );
  }
}
