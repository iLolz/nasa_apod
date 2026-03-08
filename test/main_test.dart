import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_apod/main.dart' as app;
import 'package:nasa_apod/src/core/di/injection_container.dart';
import 'package:nasa_apod/src/presentation/home/home_page.dart';
import 'package:nasa_apod/src/presentation/home/home_state.dart';
import 'package:nasa_apod/src/presentation/home_cubit.dart';

import 'src/presentation/test_home_cubit.dart';

void main() {
  setUp(() async {
    await sl.reset();
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('bootstrap initializes dependencies and renders app shell', (
    tester,
  ) async {
    var initCalls = 0;
    Widget? renderedApp;

    await app.bootstrap(
      initializeDependencies: () async {
        initCalls++;
        sl.registerFactory<HomeCubit>(
          () => TestHomeCubit(
            initialState: HomeState(
              status: HomeStatus.initialLoading,
              pagination: testPagination(),
            ),
          ),
        );
      },
      appRunner: (widget) {
        renderedApp = widget;
      },
    );

    expect(initCalls, 1);
    expect(renderedApp, isA<app.MyApp>());

    await tester.pumpWidget(renderedApp!);

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(HomePage), findsOneWidget);
  });
}
