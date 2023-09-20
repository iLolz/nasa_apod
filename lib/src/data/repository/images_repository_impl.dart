import 'package:nasa_apod/src/core/utils/exceptions.dart';
import 'package:nasa_apod/src/data/data_source/images_data_source.dart';
import 'package:nasa_apod/src/data/models/pagination_model.dart';
import 'package:nasa_apod/src/data/repository/images_repository.dart';
import 'package:nasa_apod/src/domain/entities/pagination.dart';

import '../../domain/entities/image_info.dart';

class ImagesRepositoryImpl extends ImagesRepository {
  final ImageDataSource _dataSource;

  const ImagesRepositoryImpl(this._dataSource);

  @override
  Future<List<ApodImage>> getImages(Pagination pagination) async {
    try {
      final paginationModel = PaginationModel.fromPagination(pagination);

      final response = await _dataSource.getImages(paginationModel);

      final data = <ApodImage>[];

      for (var item in response) {
        data.add(item.toEntity());
      }

      return data;
    } catch (e) {
      if (e is BaseException) rethrow;
      throw RepositoryException(e.toString());
    }
  }
}
