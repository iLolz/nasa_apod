import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_apod/src/presentation/home/home_state.dart';
import 'package:nasa_apod/src/presentation/home/widgets/custom_error.dart';
import 'package:nasa_apod/src/presentation/home/widgets/loaded/load_more_error.dart';
import 'package:nasa_apod/src/presentation/home_cubit.dart';

import '../../test_home_cubit.dart';

void main() {
  group('Error widgets', () {
    testWidgets('CustomError retries initial load', (tester) async {
      final cubit = TestHomeCubit(
        initialState: HomeStateError(testPagination()),
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

      await tester.tap(find.text('Tentar novamente'));

      expect(cubit.getImagesCalls, 1);
    });

    testWidgets('FailedToLoadMore retries pagination request', (tester) async {
      final cubit = TestHomeCubit(
        initialState: HomeStateLoadingMoreError(
          testPagination(),
          [testImage(title: 'Galaxy')],
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

      await tester.tap(find.text('Tentar novamente'));

      expect(cubit.loadMoreImagesCalls, 1);
    });
  });
}
