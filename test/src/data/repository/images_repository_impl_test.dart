import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_apod/src/core/utils/exceptions.dart';
import 'package:nasa_apod/src/data/data_source/images_data_source.dart';
import 'package:nasa_apod/src/data/models/apod_image_model.dart';
import 'package:nasa_apod/src/data/models/pagination_model.dart';
import 'package:nasa_apod/src/data/repository/images_repository_impl.dart';
import 'package:nasa_apod/src/domain/entities/pagination.dart';

void main() {
  group('ImagesRepositoryImpl', () {
    test('maps models to entities and reverses API order', () async {
      final dataSource = _FakeImageDataSource(
        result: [
          ApodImageModel.fromMap({
            'date': '2024-01-19',
            'explanation': 'Older image',
            'url': 'https://example.com/old.jpg',
            'title': 'Older',
            'media_type': 'image',
          }),
          ApodImageModel.fromMap({
            'date': '2024-01-20',
            'explanation': 'Newer image',
            'url': 'https://example.com/new.jpg',
            'title': 'Newer',
            'media_type': 'image',
          }),
        ],
      );
      final repository = ImagesRepositoryImpl(dataSource);
      final pagination = Pagination(
        startDate: DateTime(2024, 1, 10),
        endDate: DateTime(2024, 1, 20),
        thumbs: true,
      );

      final images = await repository.getImages(pagination);

      expect(dataSource.receivedPagination?.startDate, pagination.startDate);
      expect(dataSource.receivedPagination?.endDate, pagination.endDate);
      expect(images, hasLength(2));
      expect(images.first.title, 'Newer');
      expect(images.last.title, 'Older');
    });

    test('rethrows known base exceptions', () async {
      final dataSource = _FakeImageDataSource(
        error: DataSourceException('broken'),
      );
      final repository = ImagesRepositoryImpl(dataSource);

      expect(
        () => repository.getImages(_pagination()),
        throwsA(isA<DataSourceException>()),
      );
    });

    test('wraps unknown exceptions with RepositoryException', () async {
      final dataSource = _FakeImageDataSource(
        error: Exception('broken'),
      );
      final repository = ImagesRepositoryImpl(dataSource);

      expect(
        () => repository.getImages(_pagination()),
        throwsA(isA<RepositoryException>()),
      );
    });
  });
}

Pagination _pagination() {
  return Pagination(
    startDate: DateTime(2024, 1, 10),
    endDate: DateTime(2024, 1, 20),
    thumbs: true,
  );
}

class _FakeImageDataSource implements ImageDataSource {
  _FakeImageDataSource({
    this.result = const [],
    this.error,
  });

  final List<ApodImageModel> result;
  final Object? error;
  PaginationModel? receivedPagination;

  @override
  Future<List<ApodImageModel>> getImages(PaginationModel p) async {
    receivedPagination = p;

    if (error != null) {
      throw error!;
    }

    return result;
  }
}
