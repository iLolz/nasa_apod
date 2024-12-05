import 'dart:isolate';

import '../../../../core/services/error_service.dart';
import '../../../../core/utils/exceptions.dart';
import '../../domain/entities/apod_image.dart';
import '../../domain/entities/pagination.dart';
import '../data_source/images_data_source.dart';
import '../models/pagination_model.dart';
import 'images_repository.dart';

class ImagesRepositoryImpl extends ImagesRepository {
  final ImageDataSource _dataSource;
  final ErrorService errorService;

  const ImagesRepositoryImpl(this._dataSource, this.errorService);

  @override
  Future<List<ApodImage>> getImages(Pagination pagination) async {
    try {
      final paginationModel = PaginationModel.fromPagination(pagination);

      final response = await Isolate.run(() async {
        final response = await _dataSource.getImages(paginationModel);
        final data = <ApodImage>[];

        for (final item in response) {
          data.add(item.toEntity());
        }
        return data.reversed.toList();
      });

      return response;
    } catch (e, s) {
      if (e is BaseException) rethrow;

      errorService.recordError(
        e,
        stackTrace: s,
        reason: 'ImagesRepositoryImpl',
      );
      throw RepositoryException(e.toString());
    }
  }
}
