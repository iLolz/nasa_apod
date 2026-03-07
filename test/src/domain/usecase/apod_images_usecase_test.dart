import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_apod/src/core/utils/exceptions.dart';
import 'package:nasa_apod/src/data/repository/images_repository.dart';
import 'package:nasa_apod/src/domain/entities/apod_image.dart';
import 'package:nasa_apod/src/domain/entities/pagination.dart';
import 'package:nasa_apod/src/domain/usecase/apod_images_usecase.dart';

void main() {
  group('ApodImagesUsecase', () {
    test('returns images from repository', () async {
      final repository = _FakeImagesRepository(
        result: [_image(title: 'Galaxy')],
      );
      final usecase = ApodImagesUsecase(repository);

      final images = await usecase.call(_pagination());

      expect(images, hasLength(1));
      expect(images.first.title, 'Galaxy');
    });

    test('rethrows known base exceptions', () async {
      final repository = _FakeImagesRepository(
        error: RepositoryException('broken'),
      );
      final usecase = ApodImagesUsecase(repository);

      expect(
        () => usecase.call(_pagination()),
        throwsA(isA<RepositoryException>()),
      );
    });

    test('wraps unknown exceptions with UsecaseException', () async {
      final repository = _FakeImagesRepository(
        error: Exception('broken'),
      );
      final usecase = ApodImagesUsecase(repository);

      expect(
        () => usecase.call(_pagination()),
        throwsA(isA<UsecaseException>()),
      );
    });
  });
}

class _FakeImagesRepository implements ImagesRepository {
  _FakeImagesRepository({
    this.result = const [],
    this.error,
  });

  final List<ApodImage> result;
  final Object? error;

  @override
  Future<List<ApodImage>> getImages(Pagination pagination) async {
    if (error != null) {
      throw error!;
    }

    return result;
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

Pagination _pagination() {
  return Pagination(
    startDate: DateTime(2024, 1, 10),
    endDate: DateTime(2024, 1, 20),
    thumbs: true,
  );
}
