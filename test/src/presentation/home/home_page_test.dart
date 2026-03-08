import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_apod/src/core/di/injection_container.dart';
import 'package:nasa_apod/src/presentation/home/home_page.dart';
import 'package:nasa_apod/src/presentation/home/home_state.dart';
import 'package:nasa_apod/src/presentation/home_cubit.dart';

import '../test_home_cubit.dart';

void main() {
  setUp(() async {
    await sl.reset();
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('HomePage resolves cubit from GetIt and triggers initial load',
      (tester) async {
    final cubit = TestHomeCubit(
      initialState: HomeState(
        status: HomeStatus.initialLoading,
        pagination: testPagination(),
      ),
    );
    sl.registerFactory<HomeCubit>(() => cubit);

    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );

    expect(cubit.getImagesCalls, 1);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
