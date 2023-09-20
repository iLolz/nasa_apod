import 'package:nasa_apod/src/core/utils/exceptions.dart';

import '../../data/repository/images_repository.dart';
import '../entities/image_info.dart';
import '../entities/pagination.dart';

class ApodImagesUsecase {
  final ImagesRepository _repository;

  ApodImagesUsecase(this._repository);

  Future<List<ApodImage>> call(Pagination pagination) async {
    try {
      return await _repository.getImages(pagination);
    } catch (e) {
      if (e is BaseException) rethrow;

      throw UsecaseException(e.toString());
    }
  }
}
