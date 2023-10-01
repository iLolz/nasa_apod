import 'dart:developer';

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

      final data = <ApodImageModel>[];

      for (final item in response.data) {
        try {
          data.add(ApodImageModel.fromMap(item));
        } catch (e) {
          if ((item as Map<String, dynamic>).containsKey('date')) {
            log(
              'Image with date ${item['date']} is not available',
              name: 'ImagesDataSourceImpl | ApodImageModel.fromMap',
              error: e,
            );
          } else {
            log(
              'Error while parsing image',
              name: 'ImagesDataSourceImpl | ApodImageModel.fromMap',
              error: e,
            );
          }
        }
      }

      return data;
    } catch (e, s) {
      log(s.toString(), error: e, stackTrace: s);
      if (e is BaseException) rethrow;
      throw DataSourceException(e.toString());
    }
  }
}
