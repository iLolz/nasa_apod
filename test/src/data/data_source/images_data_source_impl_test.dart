import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_apod/src/core/utils/exceptions.dart';
import 'package:nasa_apod/src/data/data_source/images_data_source_impl.dart';
import 'package:nasa_apod/src/data/models/pagination_model.dart';

void main() {
  group('ImagesDataSourceImpl', () {
    test('requests APOD images with the expected endpoint and query', () async {
      final adapter = _FakeHttpClientAdapter((options) {
        expect(options.path, '/planetary/apod');
        expect(options.queryParameters, _pagination().toMap());

        return [
          {
            'date': '2024-01-20',
            'explanation': 'A nebula.',
            'hdurl': 'https://example.com/hd.jpg',
            'url': 'https://example.com/image.jpg',
            'title': 'Nebula',
            'media_type': 'image',
          },
        ];
      });
      final dataSource = ImagesDataSourceImpl(_dio(adapter));

      final result = await dataSource.getImages(_pagination());

      expect(result, hasLength(1));
      expect(result.single.title, 'Nebula');
      expect(result.single.imageUrl, 'https://example.com/image.jpg');
      expect(result.single.hdImageUrl, 'https://example.com/hd.jpg');
    });

    test('skips malformed payload rows and keeps valid images', () async {
      final adapter = _FakeHttpClientAdapter((_) {
        return [
          {
            'date': '2024-01-20',
            'explanation': 'Valid image.',
            'hdurl': 'https://example.com/hd.jpg',
            'url': 'https://example.com/image.jpg',
            'title': 'Valid',
            'media_type': 'image',
          },
          {
            'date': 'not-a-date',
            'explanation': 'Broken image.',
            'url': 'https://example.com/broken.jpg',
            'title': 'Broken',
            'media_type': 'image',
          },
        ];
      });
      final dataSource = ImagesDataSourceImpl(_dio(adapter));

      final result = await dataSource.getImages(_pagination());

      expect(result, hasLength(1));
      expect(result.single.title, 'Valid');
    });

    test('parses video rows without thumbnails safely', () async {
      final adapter = _FakeHttpClientAdapter((_) {
        return [
          {
            'date': '2024-01-20',
            'explanation': 'Video entry.',
            'url': 'https://youtube.com/watch?v=abc123',
            'title': 'Video',
            'media_type': 'video',
          },
        ];
      });
      final dataSource = ImagesDataSourceImpl(_dio(adapter));

      final result = await dataSource.getImages(_pagination());

      expect(result.single.mediaType, 'video');
      expect(result.single.imageUrl, isEmpty);
      expect(result.single.hdImageUrl, 'https://youtube.com/watch?v=abc123');
    });

    test('wraps Dio failures with DataSourceException', () async {
      final adapter = _FakeHttpClientAdapter((options) {
        throw DioException(
          requestOptions: options,
          message: 'network down',
        );
      });
      final dataSource = ImagesDataSourceImpl(_dio(adapter));

      expect(
        () => dataSource.getImages(_pagination()),
        throwsA(isA<DataSourceException>()),
      );
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

Dio _dio(HttpClientAdapter adapter) {
  return Dio(
    BaseOptions(baseUrl: 'https://example.com'),
  )..httpClientAdapter = adapter;
}

class _FakeHttpClientAdapter implements HttpClientAdapter {
  _FakeHttpClientAdapter(this._handler);

  final Object Function(RequestOptions options) _handler;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final response = _handler(options);

    if (response is Exception) {
      throw response;
    }

    final encodedBody = utf8.encode(jsonEncode(response));

    return ResponseBody.fromBytes(
      encodedBody,
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }
}
