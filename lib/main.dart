import 'package:fitness_app/features/auth/presentation/login_screen.dart';
import 'package:fitness_app/features/exercises/data/models/exercise_model.dart';
import 'package:fitness_app/features/navigation/main_navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Provider لإدارة الوضع الليلي/النهاري
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
var settingsBox = await Hive.openBox('settings');

  Hive.registerAdapter(ExerciseModelAdapter());
  await Hive.openBox<ExerciseModel>('favoritesBox');

  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness App',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
      ),
      themeMode: themeMode, // الوضع الليلي/النهاري ديناميكي
      home: const AuthCheck(),
    );
  }
}

/// صفحة تتحقق من تسجيل الدخول
class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          // المستخدم مسجل الدخول
          return const MainNavigationScreen();
        } else {
          // المستخدم غير مسجل الدخول
          return const AuthScreen();
        }
      },
    );
  }
}
