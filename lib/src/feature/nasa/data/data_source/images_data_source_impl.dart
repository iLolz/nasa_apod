import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/utils/exceptions.dart';
import '../models/apod_image_model.dart';
import '../models/pagination_model.dart';
import 'images_data_source.dart';

class ImagesDataSourceImpl extends ImageDataSource {
  const ImagesDataSourceImpl(super.client, super.errorService);

  @override
  Future<List<ApodImageModel>> getImages(PaginationModel p) async {
    try {
      final response = await client.get(
        '/planetary/apod',
        queryParameters: p.toMap(),
      );

      final data = <ApodImageModel>[];

      for (final item in response.data) {
        try {
          data.add(ApodImageModel.fromMap(item));
        } catch (e, s) {
          errorService.recordError(
            e,
            stackTrace: s,
            reason: 'ApodImageModel.fromMap',
          );
        }
      }

      return data;
    } on DioException catch (e, s) {
      errorService.recordError(
        e,
        stackTrace: s,
        reason: 'ImagesDataSourceImpl',
      );
      throw DataSourceException(e.message!);
    } on HttpException catch (e, s) {
      errorService.recordError(
        e,
        stackTrace: s,
        reason: 'ImagesDataSourceImpl',
      );
      throw DataSourceException(e.message);
    } catch (e, s) {
      errorService.recordError(
        e,
        stackTrace: s,
        reason: 'ImagesDataSourceImpl',
      );

      if (e is BaseException) rethrow;
      throw DataSourceException(e.toString());
    }
  }
}
