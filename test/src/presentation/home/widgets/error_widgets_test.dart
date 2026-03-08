import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_apod/src/presentation/home/home_state.dart';
import 'package:nasa_apod/src/presentation/home/widgets/custom_error.dart';
import 'package:nasa_apod/src/presentation/home/widgets/error_panel.dart';
import 'package:nasa_apod/src/presentation/home/widgets/loaded/load_more_error.dart';
import 'package:nasa_apod/src/presentation/home_cubit.dart';

import '../../test_home_cubit.dart';

void main() {
  group('Error widgets', () {
    testWidgets('CustomError retries initial load', (tester) async {
      final cubit = TestHomeCubit(
        initialState: HomeState(
          status: HomeStatus.initialError,
          pagination: testPagination(),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<HomeCubit>.value(
            value: cubit,
            child: const Scaffold(
              body: CustomError(),
            ),
          ),
        ),
      );

      expect(find.byType(ErrorPanel), findsOneWidget);
      expect(find.text('Falha ao carregar a galeria'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);

      await tester.tap(find.text('Tentar novamente'));

      expect(cubit.getImagesCalls, 1);
    });

    testWidgets('FailedToLoadMore retries pagination request', (tester) async {
      final cubit = TestHomeCubit(
        initialState: HomeState(
          status: HomeStatus.loadMoreError,
          pagination: testPagination(),
          images: [testImage(title: 'Galaxy')],
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<HomeCubit>.value(
            value: cubit,
            child: const Scaffold(
              body: FailedToLoadMore(),
            ),
          ),
        ),
      );

      expect(find.byType(ErrorPanel), findsOneWidget);
      expect(find.text('Falha ao carregar mais itens'), findsOneWidget);

      await tester.tap(find.text('Tentar novamente'));

      expect(cubit.loadMoreImagesCalls, 1);
    });
  });
}
