import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_apod/src/data/data_source/images_local_data_source_impl.dart';
import 'package:nasa_apod/src/data/models/apod_image_model.dart';
import 'package:nasa_apod/src/data/models/pagination_model.dart';

void main() {
  group('ImagesLocalDataSourceImpl', () {
    test('returns null when cache file does not exist', () async {
      final tempDir = await Directory.systemTemp.createTemp('apod_cache_test');
      final dataSource = ImagesLocalDataSourceImpl(
        directoryProvider: () async => tempDir,
      );

      final images = await dataSource.getImages(_pagination());

      expect(images, isNull);

      await tempDir.delete(recursive: true);
    });

    test('saves and restores cached images for a pagination window', () async {
      final tempDir = await Directory.systemTemp.createTemp('apod_cache_test');
      final dataSource = ImagesLocalDataSourceImpl(
        directoryProvider: () async => tempDir,
      );
      final models = [
        ApodImageModel.fromMap({
          'date': '2024-01-20',
          'explanation': 'A nebula.',
          'hdurl': 'https://example.com/hd.jpg',
          'url': 'https://example.com/image.jpg',
          'title': 'Nebula',
          'media_type': 'image',
        }),
      ];

      await dataSource.saveImages(_pagination(), models);
      final restoredImages = await dataSource.getImages(_pagination());

      expect(restoredImages, isNotNull);
      expect(restoredImages, hasLength(1));
      expect(restoredImages!.single.title, 'Nebula');
      expect(restoredImages.single.hdImageUrl, 'https://example.com/hd.jpg');

      await tempDir.delete(recursive: true);
    });
  });
}

PaginationModel _pagination() {
  return PaginationModel(
    startDate: DateTime(2024, 1, 10),
    endDate: DateTime(2024, 1, 20),
    thumbs: true,
  );
}
