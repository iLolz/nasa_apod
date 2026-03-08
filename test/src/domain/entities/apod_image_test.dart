import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_apod/src/domain/entities/apod_image.dart';

void main() {
  group('ApodImage', () {
    test('recognizes valid image urls', () {
      final image = ApodImage(
        previewUrl: 'https://example.com/image.jpg',
        contentUrl: 'https://example.com/hd.jpg',
        title: 'Galaxy',
        description: 'Description',
        date: DateTime(2024, 1, 20),
        displayDate: '20/01/2024',
        mediaType: ApodMediaType.image,
      );

      expect(image.hasValidPreviewUrl, isTrue);
      expect(image.hasValidContentUrl, isTrue);
      expect(image.isVideo, isFalse);
    });

    test('rejects empty or malformed urls', () {
      final image = ApodImage(
        previewUrl: '',
        contentUrl: 'not-a-url',
        title: 'Galaxy',
        description: 'Description',
        date: DateTime(2024, 1, 20),
        displayDate: '20/01/2024',
        mediaType: ApodMediaType.image,
      );

      expect(image.hasValidPreviewUrl, isFalse);
      expect(image.hasValidContentUrl, isFalse);
    });
  });
}
