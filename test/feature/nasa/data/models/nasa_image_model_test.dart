import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_apod/src/feature/nasa/data/models/apod_image_model.dart';
import 'package:nasa_apod/src/feature/nasa/domain/entities/apod_image.dart';

void main() {
  final tApodImageModel = ApodImageModel(
    date: DateTime(2021, 10, 1),
    explanation: 'Test explanation',
    hdImageUrl: 'https://example.com/hdimage.jpg',
    title: 'Test Title',
    mediaType: 'image',
    imageUrl: 'https://example.com/image.jpg',
  );

  final tApodImageModelVideo = ApodImageModel(
    date: DateTime(2021, 10, 1),
    explanation: 'Test explanation',
    hdImageUrl: 'https://example.com/video.mp4',
    title: 'Test Title',
    mediaType: 'video',
    imageUrl: 'https://example.com/thumbnail.jpg',
  );

  test('should be a subclass of ApodImage entity', () {
    expect(tApodImageModel, isA<ApodImage>());
  });

  test('should return a valid model from JSON', () {
    final jsonMap = <String, dynamic>{
      'date': '2021-10-01',
      'explanation': 'Test explanation',
      'hdurl': 'https://example.com/hdimage.jpg',
      'title': 'Test Title',
      'media_type': 'image',
      'url': 'https://example.com/image.jpg',
    };

    final result = ApodImageModel.fromMap(jsonMap);

    expect(result, tApodImageModel);
  });

  test('should return a valid model from JSON with video', () {
    final jsonMap = <String, dynamic>{
      'date': '2021-10-01',
      'explanation': 'Test explanation',
      'url': 'https://example.com/video.mp4',
      'title': 'Test Title',
      'media_type': 'video',
      'thumbnail_url': 'https://example.com/thumbnail.jpg',
    };

    final result = ApodImageModel.fromMap(jsonMap);

    expect(result, tApodImageModelVideo);
  });

  test('should convert model to entity', () {
    final result = tApodImageModel.toEntity();

    expect(
      result,
      ApodImage(
        date: DateTime(2021, 10, 1),
        description: 'Test explanation',
        imageUrl: 'https://example.com/image.jpg',
        title: 'Test Title',
        mediaType: 'image',
        hdImageUrl: 'https://example.com/hdimage.jpg',
      ),
    );
  });

  test('should convert model to entity with video', () {
    final result = tApodImageModelVideo.toEntity();

    expect(
      result,
      ApodImage(
        date: DateTime(2021, 10, 1),
        description: 'Test explanation',
        imageUrl: 'https://example.com/thumbnail.jpg',
        title: 'Test Title',
        mediaType: 'video',
        hdImageUrl: 'https://example.com/video.mp4',
      ),
    );
  });
}
