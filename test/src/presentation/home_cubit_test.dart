import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_apod/src/core/utils/exceptions.dart';
import 'package:nasa_apod/src/domain/entities/apod_image.dart';
import 'package:nasa_apod/src/domain/entities/pagination.dart';
import 'package:nasa_apod/src/domain/usecase/apod_images_usecase.dart';
import 'package:nasa_apod/src/presentation/home/home_state.dart';
import 'package:nasa_apod/src/presentation/home_cubit.dart';

void main() {
  group('HomeCubit', () {
    test('getImages emits loading then loaded and advances pagination',
        () async {
      final usecase = _FakeApodImagesUsecase(
        responses: [
          [_image(title: 'Galaxy')],
        ],
      );
      final cubit = HomeCubit(usecase);
      final stateExpectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<HomeStateLoading>(),
          isA<HomeStateLoaded>(),
        ]),
      );

      await cubit.getImages();
      await stateExpectation;

      final loadedState = cubit.state as HomeStateLoaded;

      expect(usecase.receivedPaginations, hasLength(1));
      expect(loadedState.images.single.title, 'Galaxy');
      expect(
        loadedState.pagination.startDate,
        usecase.receivedPaginations.single.next().startDate,
      );

      await cubit.close();
    });

    test('getImages emits error state and rethrows on failure', () async {
      final usecase = _FakeApodImagesUsecase(
        errors: [UsecaseException('broken')],
      );
      final cubit = HomeCubit(usecase);
      final stateExpectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<HomeStateLoading>(),
          isA<HomeStateError>(),
        ]),
      );

      await expectLater(
        cubit.getImages(),
        throwsA(isA<UsecaseException>()),
      );
      await stateExpectation;

      expect(cubit.state, isA<HomeStateError>());

      await cubit.close();
    });

    test('loadMoreImages appends items and advances pagination', () async {
      final usecase = _FakeApodImagesUsecase(
        responses: [
          [_image(title: 'First page')],
          [_image(title: 'Second page')],
        ],
      );
      final cubit = HomeCubit(usecase);

      await cubit.getImages();
      final stateExpectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<HomeStateLoadingMore>(),
          isA<HomeStateLoaded>(),
        ]),
      );
      await cubit.loadMoreImages();
      await stateExpectation;

      final loadedState = cubit.state as HomeStateLoaded;

      expect(loadedState.images, hasLength(2));
      expect(loadedState.images.first.title, 'First page');
      expect(loadedState.images.last.title, 'Second page');
      expect(usecase.receivedPaginations, hasLength(2));
      expect(
        loadedState.pagination.startDate,
        usecase.receivedPaginations.last.startDate,
      );

      await cubit.close();
    });

    test('loadMoreImages emits error state and rethrows on failure', () async {
      final usecase = _FakeApodImagesUsecase(
        responses: [
          [_image(title: 'First page')],
        ],
        errors: [
          UsecaseException('broken'),
        ],
      );
      final cubit = HomeCubit(usecase);

      await cubit.getImages();
      final stateExpectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<HomeStateLoadingMore>(),
          isA<HomeStateLoadingMoreError>(),
        ]),
      );
      await expectLater(
        cubit.loadMoreImages(),
        throwsA(isA<UsecaseException>()),
      );
      await stateExpectation;

      final errorState = cubit.state as HomeStateLoadingMoreError;

      expect(errorState.images.single.title, 'First page');

      await cubit.close();
    });
  });
}

class _FakeApodImagesUsecase implements ApodImagesUsecase {
  _FakeApodImagesUsecase({
    List<List<ApodImage>> responses = const [],
    List<Object> errors = const [],
  })  : _responses = Queue<List<ApodImage>>.from(responses),
        _errors = Queue<Object>.from(errors);

  final Queue<List<ApodImage>> _responses;
  final Queue<Object> _errors;
  final List<Pagination> receivedPaginations = [];

  @override
  Future<List<ApodImage>> call(Pagination pagination) async {
    receivedPaginations.add(pagination);

    if (_responses.isNotEmpty) {
      return _responses.removeFirst();
    }

    if (_errors.isNotEmpty) {
      throw _errors.removeFirst();
    }

    return [];
  }
}

ApodImage _image({required String title}) {
  return ApodImage(
    imageUrl: 'https://example.com/image.jpg',
    hdImageUrl: 'https://example.com/hd.jpg',
    title: title,
    description: 'Description',
    date: DateTime(2024, 1, 20),
    mediaType: 'image',
  );
}
