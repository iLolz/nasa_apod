import 'package:dio/dio.dart';
import 'package:nasa_apod/src/data/data_source/images_data_source.dart';
import 'package:nasa_apod/src/data/models/image_info_model.dart';

import '../models/pagination_model.dart';

class ImagesDataSourceImpl extends ImageDataSource {
  final Dio _client;

  const ImagesDataSourceImpl(this._client);

  @override
  Future<List<ImageInfoModel>> getImages(PaginationModel p) async {
    try {
      final response = await _client.get(
        '/planetary/apod',
        queryParameters: p.toMap(),
      );

      final data = <ImageInfoModel>[];

      for (var item in response.data) {
        data.add(ImageInfoModel.fromMap(item));
      }

      return data;
    } catch (e) {
      rethrow;
    }
  }
}
