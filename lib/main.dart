import 'package:flutter/material.dart';

import 'src/core/di/injection_container.dart' as di;
import 'src/presentation/home/home_page.dart';

Future<void> bootstrap({
  Future<void> Function()? initializeDependencies,
  void Function(Widget app)? appRunner,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await (initializeDependencies ?? di.init)();
  (appRunner ?? runApp)(const MyApp());
}

void main() {
  bootstrap();
}

class MyApp extends StatelessWidget {
  static const _seedColor = Color(0xFF0F766E);

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'NASA APOD',
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F7F6),
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
        cardTheme: CardThemeData(
          color: colorScheme.surface,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: colorScheme.primary,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
