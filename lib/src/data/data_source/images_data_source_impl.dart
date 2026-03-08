import 'dart:developer';
import 'dart:isolate';

import 'package:dio/dio.dart';

import '../../core/utils/exceptions.dart';
import '../models/apod_image_model.dart';
import '../models/pagination_model.dart';
import 'images_data_source.dart';

class ImagesDataSourceImpl extends ImageDataSource {
  final Dio _client;

  const ImagesDataSourceImpl(this._client);

  @override
  Future<List<ApodImageModel>> getImages(PaginationModel p) async {
    try {
      final response = await _client.get(
        '/planetary/apod',
        queryParameters: p.toMap(),
      );

      final payload = (response.data as List<dynamic>)
          .map(
            (item) => Map<String, dynamic>.from(item as Map),
          )
          .toList(growable: false);

      final result = await Isolate.run(
        () => _parseApodImages(payload),
      );

      for (final skippedItem in result.skippedItems) {
        if (skippedItem.date != null) {
          log(
            'Image with date ${skippedItem.date} is not available',
            name: 'ImagesDataSourceImpl | ApodImageModel.fromMap',
            error: skippedItem.error,
          );
        } else {
          log(
            'Error while parsing image',
            name: 'ImagesDataSourceImpl | ApodImageModel.fromMap',
            error: skippedItem.error,
          );
        }
      }

      return result.data;
    } catch (e, s) {
      log(s.toString(), error: e, stackTrace: s);
      if (e is BaseException) rethrow;
      throw DataSourceException(e.toString());
    }
  }
}

_ParseResult _parseApodImages(List<Map<String, dynamic>> payload) {
  final data = <ApodImageModel>[];
  final skippedItems = <_SkippedItem>[];

  for (final item in payload) {
    try {
      data.add(ApodImageModel.fromMap(item));
    } catch (e) {
      skippedItems.add(
        _SkippedItem(
          date: item['date']?.toString(),
          error: e.toString(),
        ),
      );
    }
  }

  return _ParseResult(
    data: data,
    skippedItems: skippedItems,
  );
}

class _ParseResult {
  const _ParseResult({
    required this.data,
    required this.skippedItems,
  });

  final List<ApodImageModel> data;
  final List<_SkippedItem> skippedItems;
}

class _SkippedItem {
  const _SkippedItem({
    required this.date,
    required this.error,
  });

  final String? date;
  final String error;
}
