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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NASA APOD',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
