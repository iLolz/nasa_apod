import 'package:dio/dio.dart';
import 'package:nasa_apod/src/core/utils/exceptions.dart';
import 'package:nasa_apod/src/data/data_source/images_data_source.dart';
import 'package:nasa_apod/src/data/models/image_info_model.dart';

import '../models/pagination_model.dart';

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

      for (var item in response.data) {
        data.add(ApodImageModel.fromMap(item));
      }

      return data;
    } catch (e) {
      if (e is BaseException) rethrow;
      throw DataSourceException(e.toString());
    }
  }
}
