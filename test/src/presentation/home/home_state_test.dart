import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_apod/src/presentation/home/home_state.dart';

import '../test_home_cubit.dart';

void main() {
  group('HomeState', () {
    test('initial creates explicit bootstrap state', () {
      final state = HomeState.initial();

      expect(state.status, HomeStatus.initial);
      expect(state.images, isEmpty);
      expect(state.error, isNull);
      expect(state.isInitialLoading, isTrue);
      expect(state.showsLoadedContent, isFalse);
      expect(state.canLoadMore, isFalse);
    });

    test('copyWith updates fields and preserves unspecified values', () {
      final state = HomeState(
        status: HomeStatus.loaded,
        pagination: testPagination(),
        images: [testImage(title: 'Galaxy')],
      );

      final updated = state.copyWith(
        status: HomeStatus.loadMoreError,
        error: const HomeError(
          type: HomeErrorType.unknown,
          message: 'broken',
        ),
      );

      expect(updated.status, HomeStatus.loadMoreError);
      expect(updated.pagination, state.pagination);
      expect(updated.images, state.images);
      expect(updated.error?.message, 'broken');
      expect(updated.hasLoadMoreError, isTrue);
      expect(updated.showsLoadedContent, isTrue);
      expect(updated.canLoadMore, isTrue);
    });

    test('copyWith can clear error message explicitly', () {
      final state = HomeState(
        status: HomeStatus.initialError,
        pagination: testPagination(),
        error: const HomeError(
          type: HomeErrorType.unknown,
          message: 'broken',
        ),
      );

      final updated = state.copyWith(error: null);

      expect(updated.error, isNull);
      expect(updated.hasInitialError, isTrue);
    });
  });
}
