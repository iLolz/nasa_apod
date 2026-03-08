import '../../core/utils/exceptions.dart';
import '../../domain/entities/apod_image.dart';
import '../../domain/entities/pagination.dart';
import '../data_source/images_data_source.dart';
import '../data_source/images_local_data_source.dart';
import '../models/apod_image_model.dart';
import '../models/pagination_model.dart';
import 'images_repository.dart';

class ImagesRepositoryImpl extends ImagesRepository {
  final ImageDataSource _dataSource;
  final ImagesLocalDataSource _localDataSource;

  const ImagesRepositoryImpl(
    this._dataSource,
    this._localDataSource,
  );

  @override
  Future<List<ApodImage>> getImages(Pagination pagination) async {
    try {
      final paginationModel = PaginationModel.fromPagination(pagination);
      final cachedResponse = await _localDataSource.getImages(paginationModel);

      if (cachedResponse != null) {
        return _toEntities(cachedResponse);
      }

      final response = await _dataSource.getImages(paginationModel);
      await _localDataSource.saveImages(paginationModel, response);

      return _toEntities(response);
    } catch (e) {
      if (e is BaseException) rethrow;
      throw RepositoryException(e.toString());
    }
  }

  List<ApodImage> _toEntities(List<ApodImageModel> response) {
    final data = <ApodImage>[];

    for (final item in response) {
      data.add(item.toEntity());
    }

    return data.reversed.toList();
  }
}
