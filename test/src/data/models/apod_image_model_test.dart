import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_apod/src/data/models/apod_image_model.dart';

void main() {
  group('ApodImageModel.fromMap', () {
    test('parses image payload using hdurl when available', () {
      final model = ApodImageModel.fromMap({
        'date': '2024-01-20',
        'explanation': 'A nebula.',
        'hdurl': 'https://example.com/hd.jpg',
        'url': 'https://example.com/image.jpg',
        'title': 'Nebula',
        'media_type': 'image',
      });

      expect(model.date, DateTime(2024, 1, 20));
      expect(model.explanation, 'A nebula.');
      expect(model.hdImageUrl, 'https://example.com/hd.jpg');
      expect(model.imageUrl, 'https://example.com/image.jpg');
      expect(model.mediaType, 'image');
    });

    test('falls back to url when hdurl is missing', () {
      final model = ApodImageModel.fromMap({
        'date': '2024-01-20',
        'explanation': 'A nebula.',
        'url': 'https://example.com/image.jpg',
        'title': 'Nebula',
        'media_type': 'image',
      });

      expect(model.hdImageUrl, 'https://example.com/image.jpg');
      expect(model.imageUrl, 'https://example.com/image.jpg');
    });

    test('uses thumbnail for video preview and video url as hd source', () {
      final model = ApodImageModel.fromMap({
        'date': '2024-01-20',
        'explanation': 'A space video.',
        'url': 'https://youtube.com/watch?v=abc123',
        'thumbnail_url': 'https://example.com/thumb.jpg',
        'title': 'Launch',
        'media_type': 'video',
      });

      expect(model.hdImageUrl, 'https://youtube.com/watch?v=abc123');
      expect(model.imageUrl, 'https://example.com/thumb.jpg');
      expect(model.mediaType, 'video');
    });

    test('uses empty preview url when video thumbnail is missing', () {
      final model = ApodImageModel.fromMap({
        'date': '2024-01-20',
        'explanation': 'A space video.',
        'url': 'https://youtube.com/watch?v=abc123',
        'title': 'Launch',
        'media_type': 'video',
      });

      expect(model.hdImageUrl, 'https://youtube.com/watch?v=abc123');
      expect(model.imageUrl, isEmpty);
    });
  });
}
