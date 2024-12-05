import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'src/core/services/error_service.dart';
import 'src/feature/nasa/presentation/home/home_page.dart';

void main() {
  runZonedGuarded(
    () => MyApp,
    (error, stackTrace) {
      GetIt.instance.get<ErrorService>().recordError(
            error,
            stackTrace: stackTrace,
            reason: 'main.dart',
          );
    },
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      navigatorKey: _navigatorKey,
    );
  }
}
